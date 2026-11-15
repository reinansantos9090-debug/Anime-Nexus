extends Node
const PATH := "user://anime_nexus_save_v1.json"
const BACKUP_PATH := "user://anime_nexus_save_v1.bak.json"
const SLOT_COUNT := 3
const SLOT_PATHS := [
    PATH,
    "user://anime_nexus_save_slot_2.json",
    "user://anime_nexus_save_slot_3.json"
]
const SLOT_BACKUP_PATHS := [
    BACKUP_PATH,
    "user://anime_nexus_save_slot_2.bak.json",
    "user://anime_nexus_save_slot_3.bak.json"
]
const SAVE_INTERVAL := 15.0

var elapsed := 0.0
var dirty := false
var game_state: Node
var storage_path:=PATH
var backup_storage_path:=BACKUP_PATH
var active_slot:=0
var slot_paths:Array=SLOT_PATHS.duplicate()
var slot_backup_paths:Array=SLOT_BACKUP_PATHS.duplicate()
var custom_paths:=false

func configure_paths(save_path:String,backup_path:String)->void:
    custom_paths=true
    active_slot=-1
    storage_path=save_path
    backup_storage_path=backup_path

func configure_slot_paths(paths:Array)->void:
    if paths.size()!=SLOT_COUNT:return
    custom_paths=false
    slot_paths=paths.duplicate()
    slot_backup_paths.clear()
    for path in slot_paths:
        slot_backup_paths.append(str(path)+".bak")
    _select_slot_paths(0)

func setup(state: Node) -> void:
    game_state = state
    if game_state and not game_state.state_changed.is_connected(mark_dirty):
        game_state.state_changed.connect(mark_dirty)

func _process(delta: float) -> void:
    elapsed += delta
    if elapsed >= SAVE_INTERVAL and dirty:
        elapsed = 0.0
        save_now()

func mark_dirty() -> void:
    dirty = true

func select_slot(slot:int,load_data:=true)->bool:
    if custom_paths or slot<0 or slot>=SLOT_COUNT:return false
    _select_slot_paths(slot)
    return load_now() if load_data else true

func save_slot(slot:int)->bool:
    if custom_paths or slot<0 or slot>=SLOT_COUNT:return false
    var existing:Dictionary=slot_summary(slot)
    if bool(existing.get("future_schema",false)) or bool(existing.get("protected_by_future_save",false)):return false
    _select_slot_paths(slot)
    return save_now()

func load_slot(slot:int)->bool:
    if custom_paths or slot<0 or slot>=SLOT_COUNT:return false
    var summary:Dictionary=slot_summary(slot)
    if not bool(summary.get("compatible",false)):return false
    _select_slot_paths(slot)
    return load_now()

func slot_summary(slot:int)->Dictionary:
    if slot<0 or slot>=SLOT_COUNT:return {}
    var primary_path:=str(slot_paths[slot])
    var backup_path:=str(slot_backup_paths[slot])
    var primary:Dictionary=_read(primary_path)
    if _schema_supported(primary):return _slot_summary_for_data(slot,primary,"",false)
    var backup:Dictionary=_read(backup_path)
    if _schema_supported(backup):return _slot_summary_for_data(slot,backup,"backup",int(primary.get("schema",1))>_current_schema())
    var temporary:Dictionary=_read(primary_path+".tmp")
    if _schema_supported(temporary):return _slot_summary_for_data(slot,temporary,"temporary",int(primary.get("schema",1))>_current_schema())
    var current_schema:=_current_schema()
    var has_future_schema:=int(primary.get("schema",1))>current_schema or int(backup.get("schema",1))>current_schema or int(temporary.get("schema",1))>current_schema
    var has_files:=FileAccess.file_exists(primary_path) or FileAccess.file_exists(backup_path) or FileAccess.file_exists(primary_path+".tmp")
    if not has_files:return {"slot":slot,"has_save":false,"compatible":false}
    return {"slot":slot,"has_save":true,"compatible":false,"future_schema":has_future_schema}

func _slot_summary_for_data(slot:int,data:Dictionary,recovery_source:String,protected_by_future:=false)->Dictionary:
    var hunter:Dictionary=data.get("hunter",{})
    var story:Dictionary=data.get("story",{})
    return {
        "slot":slot,
        "has_save":true,
        "compatible":true,
        "recovery_source":recovery_source,
        "protected_by_future_save":protected_by_future,
        "level":int(hunter.get("level",1)),
        "chapter":int(story.get("chapter",1)),
        "saved_at_unix":int(data.get("saved_at_unix",0))
    }

func _select_slot_paths(slot:int)->void:
    active_slot=slot
    storage_path=str(slot_paths[slot])
    backup_storage_path=str(slot_backup_paths[slot])

func save_now() -> bool:
    if game_state == null:
        return false
    var existing_primary:=_read(storage_path)
    if not existing_primary.is_empty() and not _schema_supported(existing_primary):return false
    var payload: Dictionary = game_state.data.duplicate(true)
    payload["saved_at_unix"] = Time.get_unix_time_from_system()
    var temporary_path:=storage_path+".tmp"
    var temporary:=FileAccess.open(temporary_path,FileAccess.WRITE)
    if temporary==null:return false
    temporary.store_string(JSON.stringify(payload))
    temporary.flush()
    temporary.close()
    if _read(temporary_path).is_empty():
        DirAccess.remove_absolute(ProjectSettings.globalize_path(temporary_path))
        return false

    var previous:=_read(storage_path)
    if not previous.is_empty():
        var old_file:=FileAccess.open(storage_path,FileAccess.READ)
        var backup:=FileAccess.open(backup_storage_path,FileAccess.WRITE)
        if old_file==null or backup==null:
            if old_file:old_file.close()
            if backup:backup.close()
            return false
        backup.store_string(old_file.get_as_text())
        backup.flush()
        old_file.close()
        backup.close()
        if _read(backup_storage_path).is_empty():return false

    if FileAccess.file_exists(storage_path):
        var remove_error:=DirAccess.remove_absolute(ProjectSettings.globalize_path(storage_path))
        if remove_error!=OK:return false
    var rename_error:=DirAccess.rename_absolute(
        ProjectSettings.globalize_path(temporary_path),
        ProjectSettings.globalize_path(storage_path))
    if rename_error!=OK:return false
    dirty = false
    return true

func load_now() -> bool:
    if game_state == null:
        return false
    var parsed := _read(storage_path)
    if not _schema_supported(parsed):parsed=_read(backup_storage_path)
    var recovered_temporary:=false
    if not _schema_supported(parsed):
        parsed=_read(storage_path+".tmp")
        recovered_temporary=_schema_supported(parsed)
    if not _schema_supported(parsed):return false
    if not game_state.apply_loaded(parsed):return false
    dirty = false
    if recovered_temporary:save_now()
    return true

func _current_schema()->int:
    return int(game_state.data.get("schema",8)) if game_state else 8

func _schema_supported(data:Dictionary)->bool:
    return not data.is_empty() and int(data.get("schema",1))<=_current_schema()

func _read(path: String) -> Dictionary:
    if not FileAccess.file_exists(path):
        return {}
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return {}
    var parser := JSON.new()
    var parse_result:=parser.parse(file.get_as_text())
    file.close()
    if parse_result != OK:
        return {}
    return parser.data if parser.data is Dictionary else {}

func force_save_and_flush() -> void:
    save_now()

func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_CLOSE_REQUEST:
        force_save_and_flush()
