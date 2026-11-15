extends CanvasLayer
## Local expedition picker; all metadata is bundled in MapService.

signal expedition_selected(map_id:String)
signal closed

const CAMPAIGN_EXPEDITIONS:=["nimbara","aurelio","vesper","ferrumia","ivern","umbral","nexus_core"]

var map_service:Node
var root:Control
var rows:VBoxContainer

func _ready()->void:
    layer=21
    _build()
    hide_menu()

func setup(service:Node)->void:
    map_service=service
    _populate()

func _build()->void:
    root=Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(root)
    var shade:=ColorRect.new()
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    shade.color=Color(0.01,0.02,0.05,0.88)
    root.add_child(shade)
    var panel:=Panel.new()
    panel.position=Vector2(150,44)
    panel.size=Vector2(980,620)
    root.add_child(panel)
    var title:=Label.new()
    title.text="EXPEDIÇÕES • ESCOLHA UM MUNDO"
    title.position=Vector2(30,22)
    title.add_theme_font_size_override("font_size",28)
    panel.add_child(title)
    var subtitle:=Label.new()
    subtitle.text="Conteúdo local • sem conexão • regiões em blockout de exploração"
    subtitle.position=Vector2(32,62)
    subtitle.add_theme_font_size_override("font_size",15)
    panel.add_child(subtitle)
    var scroll:=ScrollContainer.new()
    scroll.position=Vector2(24,100)
    scroll.size=Vector2(930,445)
    scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
    panel.add_child(scroll)
    rows=VBoxContainer.new()
    rows.size_flags_horizontal=Control.SIZE_EXPAND_FILL
    rows.add_theme_constant_override("separation",7)
    scroll.add_child(rows)
    var close:=Button.new()
    close.text="VOLTAR"
    close.position=Vector2(780,565)
    close.size=Vector2(170,42)
    close.pressed.connect(hide_menu)
    panel.add_child(close)

func _populate()->void:
    if rows==null or map_service==null:return
    for child in rows.get_children():
        child.queue_free()
    var ids:Array=CAMPAIGN_EXPEDITIONS.duplicate()
    ids.sort()
    for value in ids:
        var map_id:=str(value)
        if not map_service.maps.has(map_id):continue
        var data:Dictionary=map_service.get_map(map_id)
        var row:=PanelContainer.new()
        row.custom_minimum_size=Vector2(900,66)
        rows.add_child(row)
        var layout:=HBoxContainer.new()
        layout.add_theme_constant_override("separation",14)
        row.add_child(layout)
        var info:=VBoxContainer.new()
        info.size_flags_horizontal=Control.SIZE_EXPAND_FILL
        layout.add_child(info)
        var name_label:=Label.new()
        name_label.text=str(data.get("name",map_id))
        name_label.add_theme_font_size_override("font_size",19)
        info.add_child(name_label)
        var detail:=Label.new()
        detail.text="Risco %.1f • %s • %d alvos • %d min"%[
            float(data.get("difficulty",1.0)),
            str(data.get("hazard","exploração")),
            int(data.get("goal",0)),
            int(data.get("duration",0.0)/60.0)
        ]
        detail.add_theme_font_size_override("font_size",13)
        info.add_child(detail)
        var enter:=Button.new()
        var final_region_locked:=map_id=="nexus_core"
        enter.text="CAMPANHA PENDENTE" if final_region_locked else "EXPLORAR"
        enter.disabled=final_region_locked
        enter.custom_minimum_size=Vector2(180,46)
        enter.pressed.connect(_select_map.bind(map_id))
        layout.add_child(enter)

func _select_map(map_id:String)->void:
    expedition_selected.emit(map_id)

func show_menu()->void:
    visible=true
    _populate()
    root.modulate.a=0.0
    var tween:=create_tween()
    tween.tween_property(root,"modulate:a",1.0,0.14)

func hide_menu()->void:
    visible=false
    closed.emit()
