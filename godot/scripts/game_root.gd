extends Node3D
const StateScript=preload("res://scripts/core/game_state.gd")
const SaveScript=preload("res://scripts/core/save_service.gd")
const SaveSlotsMenuScript=preload("res://scripts/ui/save_slots_menu.gd")
const WorkshopMenuScript=preload("res://scripts/ui/workshop_menu.gd")
const InventoryMenuScript=preload("res://scripts/ui/inventory_menu.gd")
const ContentScript=preload("res://scripts/core/content_database.gd")
const PerfScript=preload("res://scripts/core/performance_service.gd")
const WorldScript=preload("res://scripts/world/world_service.gd")
const EnemyScript=preload("res://scripts/gameplay/enemy_agent.gd")
const CompanionScript=preload("res://scripts/gameplay/companion_agent.gd")
const CompanionRosterMenuScript=preload("res://scripts/ui/companion_roster_menu.gd")
const ExpeditionMenuScript=preload("res://scripts/ui/expedition_menu.gd")
const BossScript=preload("res://scripts/gameplay/boss_agent.gd")
const QuestScript=preload("res://scripts/gameplay/quest_service.gd")
const StoryScript=preload("res://scripts/gameplay/story_service.gd")
const EventScript=preload("res://scripts/gameplay/event_service.gd")
const InventoryScript=preload("res://scripts/gameplay/inventory_service.gd")
const CombatScript=preload("res://scripts/gameplay/combat_service.gd")
const AudioScript=preload("res://scripts/core/audio_service.gd")
const HudScript=preload("res://scripts/ui/hud.gd")
const Factory=preload("res://scripts/visuals/stylized_factory.gd")
const HunterAvatar=preload("res://scripts/visuals/hunter_avatar.gd")
const VfxScript=preload("res://scripts/visuals/vfx_service.gd")
const CutsceneScript=preload("res://scripts/gameplay/cutscene_service.gd")
const DailyScript=preload("res://scripts/gameplay/daily_service.gd")
const CoreScript=preload("res://scripts/gameplay/core_service.gd")
const ProgressionScript=preload("res://scripts/gameplay/progression_service.gd")
const WardrobeScript=preload("res://scripts/gameplay/wardrobe_service.gd")
const PortalScript=preload("res://scripts/gameplay/portal_service.gd")
const DirectorScript=preload("res://scripts/gameplay/offline_director.gd")
const OperationsMenuScript=preload("res://scripts/ui/activity_menu.gd")
const MapScript=preload("res://scripts/world/map_service.gd")
const LootScript=preload("res://scripts/gameplay/loot_service.gd")
const SkillTreeScript=preload("res://scripts/gameplay/skill_tree_service.gd")

var state:Node
var save:Node
var content:Node
var perf:Node
var world:Node
var maps:Node
var loot:Node
var skill_tree:Node
var quests:Node
var story:Node
var events:Node
var inventory:Node
var combat:Node
var audio:Node
var hud:CanvasLayer
var vfx:Node
var cutscene:CanvasLayer
var daily:Node
var cores:Node
var progression:Node
var wardrobe:Node
var portal_service:Node
var director:Node
var operations_menu:CanvasLayer
var save_slots_menu:CanvasLayer
var workshop_menu:CanvasLayer
var inventory_menu:CanvasLayer
var companion_roster_menu:CanvasLayer
var expedition_menu:CanvasLayer
var selected_expedition_map:=""
var player:Node3D
var camera:Camera3D
var enemies:Array[Node3D]=[]
var companions:Array[Node3D]=[]
var boss:Node3D
var shots:Array[Node3D]=[]
var mode:="HQ"
var attack_ready:=true
var skills=[true,true,true]
var dodge_ready:=true
var invulnerability:=0.0
var dead_timer:=0.0
var damage_buff_time:=0.0
var damage_buff:=0.0
var portal_step:=-1
var gadget_index:=0
var activity_remaining:=0.0
var activity_goal:=0
var activity_progress:=0
var clock:=0.0
var side_dialogue_active:=false
var local_dialogue_queue:Array[Dictionary]=[]
var supreme_active:=false
var supreme_remaining:=0.0

func _ready()->void:
    state=StateScript.new();add_child(state)
    content=ContentScript.new();add_child(content)
    maps=MapScript.new();add_child(maps)
    loot=LootScript.new();add_child(loot);loot.setup(state,content)
    skill_tree=SkillTreeScript.new();add_child(skill_tree);skill_tree.setup(state,content)
    save=SaveScript.new();add_child(save);save.setup(state);save.load_now()
    perf=PerfScript.new();add_child(perf)
    perf.quality_changed.connect(_apply_quality)
    world=WorldScript.new();add_child(world);world.setup(self,content,maps)
    quests=QuestScript.new();add_child(quests);quests.setup(state,content)
    quests.completed.connect(_quest_completed)
    quests.started.connect(_quest_started)
    story=StoryScript.new();add_child(story);story.setup(state)
    events=EventScript.new();add_child(events);events.setup(state,content)
    daily=DailyScript.new();add_child(daily);daily.setup(state)
    cores=CoreScript.new();add_child(cores);cores.setup(state,content)
    progression=ProgressionScript.new();add_child(progression);progression.setup(state)
    wardrobe=WardrobeScript.new();add_child(wardrobe);wardrobe.setup(state,content)
    portal_service=PortalScript.new();add_child(portal_service);portal_service.setup(state)
    director=DirectorScript.new();add_child(director);director.setup(state,content)
    vfx=VfxScript.new();add_child(vfx)
    cutscene=CutsceneScript.new();add_child(cutscene)
    cutscene.next_requested.connect(_story)
    cutscene.closed.connect(_side_dialogue_closed)
    inventory=InventoryScript.new();add_child(inventory);inventory.setup(state)
    audio=AudioScript.new();add_child(audio)
    combat=CombatScript.new();add_child(combat);combat.setup(state,audio,vfx)

    var hunter_scene:PackedScene=load("res://scenes/player/Hunter.tscn")
    player=hunter_scene.instantiate() if hunter_scene else HunterAvatar.new()
    player.name="Hunter";add_child(player)
    _set_player()
    _spawn_companions()

    camera=Camera3D.new()
    camera.projection=Camera3D.PROJECTION_ORTHOGONAL
    camera.size=clampf(float(state.data.get("settings",{}).get("camera_zoom",24.0)),14.0,32.0)
    add_child(camera)
    camera.current=true

    hud=HudScript.new();add_child(hud);hud.setup(state,quests)
    hud.attack_pressed.connect(_attack)
    hud.ability_pressed.connect(_ability)
    hud.supreme_pressed.connect(_activate_supreme)
    hud.zoom_requested.connect(_adjust_camera_zoom)
    hud.set_supreme_charge(float(state.get_hunter().get("chaos_energy",0.0)))
    hud.portal_pressed.connect(_portal)
    hud.interact_pressed.connect(_interact)
    hud.inventory_pressed.connect(_open_inventory)
    hud.story_pressed.connect(_story)
    hud.wardrobe_pressed.connect(_wardrobe)
    hud.dodge_pressed.connect(_dodge)
    hud.menu_pressed.connect(_open_operations)
    hud.arsenal_pressed.connect(_cycle_weapon)
    hud.gadget_pressed.connect(_use_gadget)

    operations_menu=OperationsMenuScript.new()
    add_child(operations_menu)
    operations_menu.selected.connect(_run_operation)
    operations_menu.set_difficulty(str(state.data.get("settings",{}).get("difficulty","adventure")))
    operations_menu.set_companion_order(str(state.data.get("party",{}).get("command","auto")))
    save_slots_menu=SaveSlotsMenuScript.new()
    add_child(save_slots_menu)
    save_slots_menu.setup(save,state)
    save_slots_menu.slot_loaded.connect(_on_save_slot_loaded)
    companion_roster_menu=CompanionRosterMenuScript.new()
    add_child(companion_roster_menu)
    companion_roster_menu.setup(state,content)
    companion_roster_menu.selection_changed.connect(_refresh_companions)
    expedition_menu=ExpeditionMenuScript.new()
    add_child(expedition_menu)
    expedition_menu.setup(maps,state)
    expedition_menu.expedition_selected.connect(_select_expedition)
    workshop_menu=WorkshopMenuScript.new()
    add_child(workshop_menu)
    workshop_menu.setup(content,inventory)
    workshop_menu.crafted.connect(_workshop_crafted)
    inventory_menu=InventoryMenuScript.new()
    add_child(inventory_menu)
    inventory_menu.setup(content,state)

    world.build_hq()
    _apply_quality(perf.current())
    quests.start("nimbara_01")
    hud.set_mode("OBSERVATÓRIO DE ÍRIS • PORTAL CENTRAL")
    if int(state.data["story"].get("chapter",1))==1 and int(state.data["story"].get("scene",0))==0:
        _story()

func _spawn_companions()->void:
    var selected:Array=state.data.get("party",{}).get("companions",[])
    var index:=0
    for companion_id in selected:
        var id:=str(companion_id)
        if not content.COMPANIONS.has(id) or index>=2:continue
        var data:Dictionary=content.COMPANIONS[id]
        var side:float=-1.0 if index==0 else 1.0
        var companion:Node3D=CompanionScript.new()
        add_child(companion)
        companion.configure(player,combat,state,id,str(data["name"]),str(data["element"]),
            str(data["role"]),data["body"],data["accent"],Vector3(2.0*side,0.0,2.4),
            float(data.get("skill_power",1.0)),float(data.get("skill_radius",4.0)),
            float(data.get("skill_cooldown",9.0)),float(data.get("slow_duration",2.2)),
            float(data.get("slow_factor",0.55)),float(data.get("support_heal",0.20)),
            float(data.get("support_energy",12.0)),float(data.get("support_threshold",0.68)))
        companions.append(companion)
        index+=1

func _refresh_companions()->void:
    for companion in companions:
        if is_instance_valid(companion):
            companion.set_combat_active(false)
            companion.queue_free()
    companions.clear()
    _spawn_companions()
    _set_companion_combat(mode!="HQ")

func _set_companion_combat(active:bool)->void:
    for companion in companions:
        if is_instance_valid(companion):
            companion.set_combat_active(active)

func _set_player()->void:
    if not is_instance_valid(player):return
    player.position=Vector3(0,0.1,6)
    var selected=content.STYLES[0]
    for item in content.STYLES:
        if item["id"]==str(state.data["wardrobe"]["style"]):
            selected=item
            break
    if player.has_method("setup"):
        player.setup(selected,str(state.data["loadout"]["weapon"]))
    else:
        for c in player.get_children():c.queue_free()
        Factory.make_hunter(player,selected["primary"],selected["secondary"],selected["head"])

func _portal()->void:
    if cutscene and cutscene.is_active():return
    audio.click()
    match mode:
        "HQ":_open_expedition_selection()
        "EXPEDITION":_enter_rift()
        "RIFT":
            if "nimbara_08" in state.data["quests"]["active"] or "aurelio_08" in state.data["quests"]["active"]:
                _enter_expedition()
            elif boss==null or not is_instance_valid(boss):
                _enter_hq()
            else:
                hud.set_mode("RIFT • DERROTE O CHEFE PARA RETORNAR AO OBSERVATÓRIO")
        "VERSUS":_enter_hq()
        _: _enter_hq()

func _open_expedition_selection()->void:
    var story_complete:=bool(state.data["story"]["flags"].get("nimbara_slice_complete",false))
    if not story_complete:
        _enter_expedition()
        return
    for active_id in state.data["quests"].get("active",[]):
        var id:=str(active_id)
        var quest:Dictionary=quests.get_quest(id)
        if id.begins_with("nimbara_side_"):
            selected_expedition_map="nimbara"
            _enter_expedition()
            return
        if not str(quest.get("map","")).is_empty():
            _enter_expedition()
            return
    expedition_menu.show_menu()

func _select_expedition(map_id:String)->void:
    if not maps.maps.has(map_id):return
    selected_expedition_map=map_id
    expedition_menu.hide_menu()
    _enter_expedition()

func _enter_hq()->void:
    mode="HQ"
    _clear_combat()
    portal_service.enter_hq()
    director.enter_hq()
    activity_remaining=0.0
    activity_progress=0
    activity_goal=0
    world.build_hq()
    hud.set_interaction_visible(false)
    player.position=Vector3(0,0.1,6)
    _set_companion_combat(false)
    for companion in companions:
        if is_instance_valid(companion):companion.reset_formation()
    hud.set_mode("PRÓLOGO DA SLICE CONCLUÍDO • NOVOS CAPÍTULOS EM PRODUÇÃO" if bool(state.data["story"]["flags"].get("nimbara_slice_complete",false)) else "OBSERVATÓRIO DE ÍRIS • PORTAL CENTRAL")

func _enter_expedition()->void:
    mode="EXPEDITION"
    var ids:Array=maps.maps.keys()
    ids.sort()
    var map_id:=selected_expedition_map
    selected_expedition_map=""
    if map_id.is_empty():
        portal_step=(portal_step+1)%ids.size()
        map_id=str(ids[portal_step%ids.size()])
    var required_map:=""
    for active_id in state.data["quests"].get("active",[]):
        if str(active_id).begins_with("nimbara_side_"):
            required_map="nimbara"
            break
    if required_map.is_empty():
        for active_id in state.data["quests"].get("active",[]):
            var active_quest:Dictionary=quests.get_quest(str(active_id))
            if not str(active_quest.get("map","")).is_empty():
                required_map=str(active_quest["map"])
                break
    if not required_map.is_empty():map_id=required_map
    var nimbara_story_complete:=bool(state.data["story"]["flags"].get("nimbara_slice_complete",false))
    if not nimbara_story_complete and (int(state.data["world"].get("completed_expeditions",0))==0 or "nimbara_08" in state.data["quests"]["active"] or "nimbara_side_01" in state.data["quests"]["active"] or "nimbara_side_02" in state.data["quests"]["active"]):
        map_id="nimbara"
    portal_service.enter_expedition(map_id)
    state.data["world"]["map_id"]=map_id
    state.state_changed.emit()
    director.start_expedition(map_id)
    world.build_biome(map_id)
    var anchor_return:bool=((map_id=="nimbara" and "nimbara_08" in state.data["quests"]["active"]) or (map_id=="aurelio" and "aurelio_08" in state.data["quests"]["active"]))
    activity_remaining=0.0 if anchor_return else maps.duration(map_id)
    activity_goal=0 if anchor_return else maps.activity_goal(map_id)
    activity_progress=0
    player.position=Vector3(0,0.1,6)
    for companion in companions:
        if is_instance_valid(companion):companion.reset_formation()
    _set_companion_combat(true)
    quests.add_map(map_id)
    _spawn_wave(0 if anchor_return else mini(16,perf.max_enemies()))
    var has_nimbara_interaction:= "nimbara_06" in state.data["quests"]["active"] or "nimbara_08" in state.data["quests"]["active"] or "nimbara_side_02" in state.data["quests"]["active"]
    var has_regional_anchor:bool=("nimbara_08" in state.data["quests"]["active"] or "aurelio_08" in state.data["quests"]["active"])
    hud.set_interaction_visible((map_id=="nimbara" and has_nimbara_interaction) or (map_id=="aurelio" and has_regional_anchor))
    hud.set_mode("ÂNCORA • APROXIME-SE PARA ESTABILIZAR" if anchor_return else "EXPEDIÇÃO • %s • 0/%d"%[maps.get_map(map_id)["name"],activity_goal])

func _interact()->void:
    if mode!="EXPEDITION":return
    var active:Array=state.data["quests"].get("active",[])
    var active_anchor_quest:=""
    if "nimbara_08" in active:active_anchor_quest="nimbara_08"
    elif "aurelio_08" in active:active_anchor_quest="aurelio_08"
    if not active_anchor_quest.is_empty():
        var region_id:=str(quests.get_quest(active_anchor_quest).get("map","nimbara"))
        var anchor_position:Vector3=maps.get_map(region_id).get("resonance_anchor",Vector3(0,0,-8.5))
        if player.position.distance_to(anchor_position)>3.2:
            hud.set_mode("ÂNCORA • APROXIME-SE DO CRISTAL NA REGIÃO")
            return
        var object_id:="resonance_anchor" if region_id=="nimbara" else "aurelio_anchor"
        quests.add_interaction(object_id)
        hud.set_interaction_visible(false)
        audio.level_up()
        return
    if ("nimbara_06" in active or "nimbara_side_02" in active) and str(portal_service.destination)=="nimbara":
        var positions:Array=maps.get_map("nimbara").get("memory_echoes",[])
        for index in range(positions.size()):
            var marker_position:Vector3=positions[index]
            if player.position.distance_to(marker_position)>3.0:continue
            var flag_id:="nimbara_memory_echo_"+str(index+1)
            if bool(state.data["story"]["flags"].get(flag_id,false)):
                hud.set_mode("ECO DE MEMÓRIA • ESTE FRAGMENTO JÁ FOI SINCRONIZADO")
                return
            state.set_story_flag(flag_id,true)
            quests.add_interaction("memory_echo")
            audio.level_up()
            var echo_quest_id:="nimbara_06" if "nimbara_06" in active else "nimbara_side_02"
            var progress:=int(state.data["quests"]["progress"].get(echo_quest_id,0))
            hud.set_mode("ECO DE MEMÓRIA • %d/3"%progress)
            if "nimbara_06" not in state.data["quests"]["active"] and "nimbara_side_02" not in state.data["quests"]["active"]:
                hud.set_interaction_visible(false)
            return
        hud.set_mode("ECO DE MEMÓRIA • APROXIME-SE DE UM CRISTAL PÁLIDO")

func _enter_rift()->void:
    var active_quests:Array=state.data["quests"].get("active",[])
    for mission_id in ["nimbara_01","nimbara_02","nimbara_03","nimbara_04","nimbara_05","nimbara_06","aurelio_01","aurelio_02","aurelio_03","aurelio_04","aurelio_05","aurelio_06"]:
        if mission_id in active_quests:
            hud.set_mode("MISSÃO • CONCLUA O OBJETIVO REGIONAL ATUAL")
            return
    if "nimbara_08" in active_quests or "aurelio_08" in active_quests:
        hud.set_mode("MISSÃO • INTERAJA COM A ÂNCORA DE RESSONÂNCIA")
        return
    var region_id:=str(state.data.get("world",{}).get("map_id","nimbara"))
    if not maps.maps.has(region_id):
        region_id="nimbara"
    if region_id=="nexus_core" and not bool(state.data["world"].get("nexus_core_unlocked",false)):
        hud.set_mode("NÚCLEO DO NEXO • A CAMPANHA AINDA NÃO DESBLOQUEOU ESTA REGIÃO")
        return
    var boss_id:=str(content.REGIONAL_BOSSES.get(region_id,"crystal_stag"))
    if not content.BOSSES.has(boss_id):
        hud.set_mode("RIFT • CONFIGURAÇÃO DE CHEFE INDISPONÍVEL")
        return
    var first_nimbara_boss:bool="nimbara_07" in active_quests
    mode="RIFT"
    portal_service.enter_rift(region_id)
    director.start_rift(region_id)
    world.build_biome(region_id)
    activity_remaining=0.0
    activity_progress=0
    activity_goal=1
    _set_companion_combat(true)
    _spawn_wave(mini(4,perf.max_enemies()) if first_nimbara_boss else mini(6,perf.max_enemies()))
    _spawn_boss(boss_id)
    hud.set_mode("CHEFE • "+str(content.BOSSES[boss_id]["name"])+" • "+str(maps.get_map(region_id)["name"]))

func _enter_versus()->void:
    mode="VERSUS"
    portal_service.enter_versus()
    director.start_versus()
    world.build_biome("sky_ruins")
    activity_remaining=75.0
    activity_goal=8
    activity_progress=0
    _set_companion_combat(true)
    _spawn_wave(mini(8,perf.max_enemies()))
    hud.set_mode("VERSUS • SIMULAÇÃO OFFLINE")

func _side_dialogue_closed()->void:
    side_dialogue_active=false
    if not local_dialogue_queue.is_empty():call_deferred("_present_next_local_dialogue")

func _show_local_quest_dialogue(title:String,speaker:String,line:String)->void:
    if cutscene==null or not is_instance_valid(cutscene):return
    local_dialogue_queue.append({"title":title,"speaker":speaker,"line":line})
    if not cutscene.is_active() and not side_dialogue_active:
        _present_next_local_dialogue()

func _present_next_local_dialogue(advance_current:=false)->void:
    if local_dialogue_queue.is_empty() or cutscene==null or not is_instance_valid(cutscene):return
    if side_dialogue_active and not advance_current:return
    if cutscene.is_active() and not (side_dialogue_active and advance_current):return
    var entry:Dictionary=local_dialogue_queue.pop_front()
    side_dialogue_active=true
    cutscene.show_line("MISSÃO • "+str(entry["title"]),str(entry["speaker"]),str(entry["line"]))

func _start_optional_quest(quest_id:String)->void:
    if mode!="HQ":
        hud.set_mode("MISSÕES SECUNDÁRIAS • CONSULTE NO OBSERVATÓRIO")
        return
    if cutscene and cutscene.is_active():
        hud.set_mode("DIÁLOGO • TERMINE A CENA ATUAL")
        return
    var completed:Array=state.data["quests"].get("completed",[])
    var active:Array=state.data["quests"].get("active",[])
    for active_id in active:
        var active_name:=str(active_id)
        if active_name.begins_with("nimbara_side_") and active_name!=quest_id:
            hud.set_mode("MISSÃO • CONCLUA A SECUNDÁRIA ATIVA PRIMEIRO")
            return
    var quest:Dictionary=quests.get_quest(quest_id)
    if quest_id in completed:
        _show_local_quest_dialogue(str(quest.get("title",quest_id)),str(quest.get("speaker","Liora")),str(quest.get("completion_dialogue","A clareira agradece.")))
        return
    if quest_id not in active:quests.start(quest_id)
    _show_local_quest_dialogue(str(quest.get("title",quest_id)),str(quest.get("speaker","Liora")),str(quest.get("start_dialogue","Ajude a clareira.")))

func _cycle_companion_order()->void:
    var order:Array=["auto","follow","retreat"]
    var party:Dictionary=state.data.get("party",{}).duplicate(true)
    var current:=str(party.get("command","auto"))
    var index:=order.find(current)
    if index<0:index=0
    var next_id:=str(order[(index+1)%order.size()])
    party["command"]=next_id
    state.data["party"]=party
    state.state_changed.emit()
    operations_menu.set_companion_order(next_id)
    var labels:Dictionary={"auto":"COMBATE AUTOMÁTICO","follow":"SEGUIR Kaien","retreat":"RECUAR PARA PERTO DE Kaien"}
    hud.set_mode("ALIADOS • "+str(labels[next_id]))

func _cycle_difficulty()->void:
    if mode!="HQ":
        hud.set_mode("DIFICULDADE • ALTERE NO OBSERVATÓRIO")
        return
    var order:Array=["casual","adventure","challenge"]
    var current:=str(state.data.get("settings",{}).get("difficulty","adventure"))
    var index:=order.find(current)
    if index<0:index=1
    var next_id:=str(order[(index+1)%order.size()])
    state.data["settings"]["difficulty"]=next_id
    state.state_changed.emit()
    var profile:Dictionary=state.difficulty_profile()
    operations_menu.set_difficulty(next_id)
    hud.set_mode("DIFICULDADE • "+str(profile["label"])+" • PROGRESSO LOCAL")

func _open_operations()->void:
    if operations_menu and not operations_menu.is_open():
        operations_menu.show_menu()

func _on_save_slot_loaded(slot_number:int)->void:
    operations_menu.set_difficulty(str(state.data.get("settings",{}).get("difficulty","adventure")))
    operations_menu.set_companion_order(str(state.data.get("party",{}).get("command","auto")))
    _refresh_companions()
    _enter_hq()
    hud.set_mode("ESPAÇO %d CARREGADO • OBSERVATÓRIO DE ÍRIS"%slot_number)

func _run_operation(action_id:String)->void:
    match action_id:
        "expedition":_enter_expedition()
        "rift":_enter_rift()
        "versus":_enter_versus()
        "daily":hud.set_mode("DIÁRIAS • "+daily.summary())
        "event":
            for item in content.EVENTS:
                var id:=str(item["id"])
                if id!=director.active_event:
                    director.start_event(id)
                    events.start(id)
                    hud.set_mode("EVENTO • "+str(item["name"]))
                    break
        "cores":
            hud.set_mode("NÚCLEOS • "+cores.summary())
        "skills":
            var unlocked_skill:String=skill_tree.unlock_next_available()
            hud.set_mode("ÁRVORE • "+unlocked_skill+" • "+skill_tree.summary())
            audio.level_up()
        "craft":
            if mode=="HQ" and workshop_menu:
                workshop_menu.show_menu()
            else:
                hud.set_mode("OFICINA • VOLTE AO OBSERVATÓRIO DE ÍRIS")
        "history":_story()
        "saves":
            if save_slots_menu:save_slots_menu.show_menu()
        "difficulty":_cycle_difficulty()
        "companions":
            if companion_roster_menu:companion_roster_menu.show_menu()
        "side_quest":_start_optional_quest("nimbara_side_01")
        "memory_quest":_start_optional_quest("nimbara_side_02")
        "companion_order":_cycle_companion_order()

func _open_inventory()->void:
    if inventory_menu:inventory_menu.show_menu()

func _workshop_crafted(recipe_id:String,success:bool)->void:
    if not success:
        hud.set_mode("OFICINA • MATERIAIS INSUFICIENTES OU PROJETO JÁ DESBLOQUEADO")
        return
    for recipe in content.RECIPES:
        if str(recipe.get("id",""))==recipe_id:
            var weapon_id:=str(recipe.get("unlock_weapon",""))
            if not weapon_id.is_empty():
                var weapon:Dictionary=content.WEAPONS.get(weapon_id,{})
                hud.set_mode("INSTRUMENTO DESBLOQUEADO • %s • USE ARSENAL PARA EQUIPAR"%str(weapon.get("name",recipe_id)))
            else:
                hud.set_mode("OFICINA • CRIADO: "+str(recipe.get("name",recipe_id)))
            audio.level_up()
            return

func _cycle_weapon()->void:
    var ids:Array=inventory.available_weapons(content)
    if ids.is_empty():return
    var current:=str(state.data["loadout"]["weapon"])
    var idx:=ids.find(current)
    idx=(idx+1)%ids.size()
    var next:=str(ids[idx])
    state.data["loadout"]["weapon"]=next
    var weapon:Dictionary=content.WEAPONS[next]
    var abilities:Array=weapon.get("abilities",[])
    for i in range(mini(3,abilities.size())):
        state.data["loadout"]["ability_"+str(i+1)]=str(abilities[i])
    state.state_changed.emit()
    if player.has_method("equip_weapon"):player.equip_weapon(next)
    hud.set_mode("ARSENAL • %s • %.0f DANO"%[str(weapon["name"]),float(weapon["damage"])])

func _adjust_camera_zoom(direction:int)->void:
    if camera==null or direction==0:return
    var settings:Dictionary=state.data.get("settings",{})
    camera.size=clampf(camera.size-float(direction)*2.0,14.0,32.0)
    settings["camera_zoom"]=camera.size
    state.data["settings"]=settings
    state.state_changed.emit()
    hud.set_mode("CÂMERA • ZOOM %d%%"%roundi((24.0/camera.size)*100.0))

func _gain_supreme_charge(amount:float)->void:
    if supreme_active or amount<=0.0 or state==null or state.native_core==null:return
    var hunter:Dictionary=state.get_hunter()
    var result:Dictionary=state.native_core.resolve_supreme_meter(float(hunter.get("chaos_energy",0.0)),amount,false)
    hunter["chaos_energy"]=float(result.get("charge",0.0))
    if hud:hud.set_supreme_charge(float(hunter["chaos_energy"]))
    state.state_changed.emit()

func _player_hit(target:Node3D,amount:float,critical:=false,element:="none")->Dictionary:
    if not is_instance_valid(target):return {}
    var final_amount:=amount
    if supreme_active:
        var form:Dictionary=content.TRANSFORMATIONS.get("kaien_sapphire_storm",{})
        final_amount*=float(form.get("damage_multiplier",1.0))
    var result:Dictionary=combat.hit(target,final_amount,critical,element)
    var dealt:=float(result.get("amount",0.0))
    if dealt>0.0:_gain_supreme_charge(minf(6.0,maxf(1.5,dealt*0.045)))
    return result

func _activate_supreme()->void:
    if supreme_active or dead_timer>0.0:return
    if mode=="HQ":
        hud.set_mode("TEMPESTADE DE SAFIRA • DISPONÍVEL DURANTE COMBATE")
        return
    var hunter:Dictionary=state.get_hunter()
    var form:Dictionary=content.TRANSFORMATIONS.get("kaien_sapphire_storm",{})
    if form.is_empty():return
    var outcome:Dictionary=state.native_core.resolve_supreme_meter(float(hunter.get("chaos_energy",0.0)),0.0,true)
    if not bool(outcome.get("activated",false)):
        hud.set_mode("RESSONÂNCIA • %d%%"%roundi(float(outcome.get("charge",0.0))))
        return
    hunter["chaos_energy"]=float(outcome.get("charge",0.0))
    supreme_active=true
    supreme_remaining=float(form.get("duration",10.0))
    hud.set_supreme_charge(0.0,true,supreme_remaining)
    hud.set_mode("TEMPESTADE DE SAFIRA • RESSONÂNCIA DESPERTA")
    if player.has_method("set_transformation"):player.set_transformation(true,form.get("color",Color("#45caff")))
    vfx.skill_burst(self,player.position,form.get("color",Color("#45caff")))
    vfx.ring(self,player.position+Vector3(0,0.04,0),3.6,Color("#8aeaff"),0.62)
    audio.skill()
    state.state_changed.emit()

func _tick_supreme(delta:float)->void:
    if not supreme_active:return
    supreme_remaining=maxf(0.0,supreme_remaining-delta)
    if supreme_remaining<=0.0:
        supreme_active=false
        if is_instance_valid(player) and player.has_method("set_transformation"):player.set_transformation(false)
        var position:=player.position if is_instance_valid(player) else Vector3.ZERO
        vfx.ring(self,position+Vector3(0,0.04,0),2.4,Color("#45caff"),0.38)
        hud.set_supreme_charge(float(state.get_hunter().get("chaos_energy",0.0)))
        hud.set_mode("RESSONÂNCIA • A TEMPESTADE DE SAFIRA SE DISSIPOU")
    else:
        hud.set_supreme_charge(float(state.get_hunter().get("chaos_energy",0.0)),true,supreme_remaining)

func _attack()->void:
    if not attack_ready or dead_timer>0.0:return
    attack_ready=false
    var weapon:Dictionary=content.WEAPONS.get(str(state.data["loadout"]["weapon"]),content.WEAPONS["volt_blades"])
    var target:=_nearest(float(weapon["range"])+1.8)
    if target:
        if player.has_method("play_attack"):player.play_attack()
        var bonus:float=_core("damage")+skill_tree.bonus("damage")+damage_buff
        var crit:float=_core("crit")+skill_tree.bonus("crit")
        var attack:Dictionary=combat.player_attack(weapon,int(state.get_hunter()["level"]),bonus,crit)
        var amount:float=float(attack["amount"])
        var critical:bool=bool(attack["critical"])
        var hit_result:Dictionary=_player_hit(target,amount,critical,str(weapon.get("element","none")))
        var displayed_amount:=float(hit_result.get("amount",amount))
        vfx.hit_burst(self,target.position+Vector3(0,1,0),Color("#ffe16a"))
        vfx.floating_number(self,target.position+Vector3(0,1.5,0),displayed_amount,critical)
    var speed_bonus:float=_core("attack_speed")+skill_tree.bonus("attack_speed")
    var cooldown_bonus:=clampf(_core("cooldown")+skill_tree.bonus("cooldown"),0.0,0.75)
    var wait:float=float(weapon["rate"])*(1.0-cooldown_bonus)/(1.0+speed_bonus)
    get_tree().create_timer(maxf(0.08,wait)).timeout.connect(func():attack_ready=true)

func _ability(i:int)->void:
    if i<0 or i>=3 or dead_timer>0.0 or not skills[i]:return
    var weapon:Dictionary=content.WEAPONS.get(str(state.data["loadout"]["weapon"]),content.WEAPONS["volt_blades"])
    var ids:Array=weapon.get("abilities",[])
    if i>=ids.size():return
    var ability:Dictionary=content.ABILITIES.get(str(ids[i]),{})
    if ability.is_empty():return
    var hunter:Dictionary=state.get_hunter()
    if float(hunter["energy"])<float(ability["energy"]):return

    skills[i]=false
    hunter["energy"]=float(hunter["energy"])-float(ability["energy"])
    daily.add("daily_skill",1)
    if player.has_method("play_skill"):player.play_skill(i)
    audio.skill()
    _execute_ability(
        str(ability.get("effect","area")),
        float(ability.get("power",1.0)),
        float(ability.get("radius",4.0)),
        int(ability.get("count",5)),
        str(weapon.get("element","none"))
    )
    var cooldown:=float(ability["cooldown"])*(1.0-clampf(_core("cooldown")+skill_tree.bonus("cooldown"),0.0,0.75))
    if supreme_active:
        var form:Dictionary=content.TRANSFORMATIONS.get("kaien_sapphire_storm",{})
        cooldown*=float(form.get("cooldown_multiplier",1.0))
    get_tree().create_timer(maxf(0.20,cooldown)).timeout.connect(func():skills[i]=true)

func _execute_ability(effect:String,power:float,radius:float,target_limit:=5,element:="none")->void:
    var origin:=player.position
    match effect:
        "dash":
            var target:=_nearest(radius+8.0)
            if target:
                var dir:Vector3=(target.position-player.position).normalized()
                player.position=target.position-dir*1.8
                _player_hit(target,55.0*power,false,element)
            vfx.skill_burst(self,player.position,Color("#66eaff"))
        "area","pull_area":
            for e in enemies.duplicate():
                if is_instance_valid(e) and e.position.distance_to(origin)<=radius:
                    _player_hit(e,48.0*power,false,element)
                    if effect=="pull_area":
                        e.position=e.position.lerp(origin,0.20)
            if boss and is_instance_valid(boss) and boss.position.distance_to(origin)<=radius:
                _player_hit(boss,65.0*power,false,element)
            vfx.skill_burst(self,origin,Color("#b990ff"))
        "slow_area":
            for e in enemies.duplicate():
                if is_instance_valid(e) and e.position.distance_to(origin)<=radius:
                    _player_hit(e,35.0*power,false,element)
                    if e.has_method("apply_slow"):e.apply_slow(3.0,0.42)
            if boss and is_instance_valid(boss) and boss.position.distance_to(origin)<=radius:
                _player_hit(boss,48.0*power,false,element)
                if boss.has_method("apply_slow"):boss.apply_slow(2.2,0.58)
            vfx.skill_burst(self,origin,Color("#68e5ee"))
        "chain":
            var candidates:Array[Node3D]=[]
            for e in enemies:
                if is_instance_valid(e):candidates.append(e)
            if boss and is_instance_valid(boss):candidates.append(boss)
            var cursor:=origin
            for target_index in range(mini(target_limit,candidates.size())):
                var nearest:Node3D=null
                var nearest_distance:=radius if target_index==0 else 4.5
                for candidate in candidates:
                    var distance:=candidate.position.distance_to(cursor)
                    if distance<nearest_distance:
                        nearest=candidate
                        nearest_distance=distance
                if nearest==null:break
                _player_hit(nearest,43.0*power if nearest!=boss else 72.0*power,false,element)
                vfx.hit_burst(self,nearest.position+Vector3(0,1.0,0),Color("#69ebff"))
                cursor=nearest.position
                candidates.erase(nearest)
            vfx.skill_burst(self,origin,Color("#7defff"))
        "multi_projectile","beam":
            var count:=0
            for e in enemies.duplicate():
                if is_instance_valid(e) and e.position.distance_to(origin)<=radius:
                    _player_hit(e,43.0*power,false,element)
                    count+=1
                    if count>=8:break
            if boss and is_instance_valid(boss) and boss.position.distance_to(origin)<=radius:
                _player_hit(boss,72.0*power,false,element)
            vfx.skill_burst(self,origin,Color("#7defff"))
        "barrier":
            invulnerability=maxf(invulnerability,2.5)
            vfx.skill_burst(self,origin,Color("#d4a7ff"))
        "buff_damage":
            damage_buff=power
            damage_buff_time=6.0
            vfx.skill_burst(self,origin,Color("#ffd65c"))
        _:
            vfx.skill_burst(self,origin,Color.WHITE)

func _use_gadget()->void:
    var gadgets:=["pulse_grenade","healing_drone","aether_mine","rift_beacon"]
    if gadgets.is_empty():return
    var id:=str(gadgets[gadget_index%gadgets.size()])
    gadget_index+=1
    if inventory.quantity(id)<=0:
        hud.set_mode("GADGET • %s x0 • FABRIQUE NA OFICINA"%id)
        return
    inventory.game_state.remove_item(id,1)
    var origin:=player.position
    match id:
        "pulse_grenade":
            for e in enemies.duplicate():
                if is_instance_valid(e) and e.position.distance_to(origin)<=5.4:combat.hit(e,110.0)
            vfx.skill_burst(self,origin,Color("#ffbe66"))
        "healing_drone":
            var h:Dictionary=state.get_hunter()
            h["hp"]=minf(float(h["max_hp"]),float(h["hp"])+90.0+float(h["level"])*4.0)
            vfx.skill_burst(self,origin,Color("#63f2a4"))
        "aether_mine":
            var target:=_nearest(7.0)
            var mine_pos:=target.position if target else origin
            for e in enemies.duplicate():
                if is_instance_valid(e) and e.position.distance_to(mine_pos)<=4.2:combat.hit(e,145.0)
            if boss and is_instance_valid(boss) and boss.position.distance_to(mine_pos)<=4.2:combat.hit(boss,190.0)
            vfx.skill_burst(self,mine_pos,Color("#67e8ff"))
        "rift_beacon":
            if mode=="EXPEDITION":
                activity_remaining=maxf(0.0,activity_remaining-15.0)
                activity_progress+=1
            vfx.skill_burst(self,origin,Color("#d7a5ff"))
    hud.set_mode("GADGET • %s • USADO"%id)
    audio.pickup()

func _spawn_wave(count:int)->void:
    _clear_combat()
    var map_id:=str(portal_service.destination)
    var pool:Array=maps.enemy_pool(map_id)
    if pool.is_empty():pool=content.MONSTERS.keys()
    var objective_monster:=""
    var objective_count:=0
    for active_id in state.data["quests"].get("active",[]):
        var quest:Dictionary=quests.get_quest(str(active_id))
        if str(quest.get("map",""))!="" and str(quest.get("map",""))!=map_id:continue
        var quest_type:=str(quest.get("type",""))
        if quest_type=="kill":
            objective_monster=str(quest.get("monster",""))
            objective_count=maxi(0,int(quest.get("target",1))-int(state.data["quests"]["progress"].get(str(active_id),0)))
        elif quest_type=="collect":
            var item_id:=str(quest.get("item",""))
            for candidate in pool:
                if item_id in content.MONSTERS.get(str(candidate),{}).get("loot",[]):
                    objective_monster=str(candidate)
                    objective_count=mini(3,maxi(0,int(quest.get("target",1))-int(state.data["quests"]["progress"].get(str(active_id),0)))
                    break
        if not objective_monster.is_empty():break
    var spawn_count:=mini(count,perf.max_enemies())
    for i in spawn_count:
        var spawn_id:=objective_monster if i<mini(objective_count,spawn_count) else str(pool[i%pool.size()])
        _spawn_enemy(i,spawn_id)

func _spawn_enemy(i:int,id:="")->void:
    var pool:Array=maps.enemy_pool(str(portal_service.destination))
    if pool.is_empty():pool=content.MONSTERS.keys()
    var kind:=id if not id.is_empty() else str(pool[i%pool.size()])
    var enemy_scene:PackedScene=load("res://scenes/enemies/Enemy.tscn")
    var e:Node3D=enemy_scene.instantiate() if enemy_scene else EnemyScript.new()
    add_child(e)
    e.position=_spawn_position(i)
    var scale:float=maps.difficulty(str(portal_service.destination))
    e.configure(kind,player,content,scale,state.difficulty_profile())
    var behavior:=str(content.MONSTERS.get(kind,{}).get("behavior","melee"))
    _attach_enemy_visual(e,behavior,i)
    e.defeated.connect(_enemy_down)
    e.projectile_requested.connect(_shot)
    e.summon_requested.connect(_enemy_summon)
    e.area_requested.connect(_enemy_area)
    enemies.append(e)

func _attach_enemy_visual(e:Node3D,behavior:String,index:int)->void:
    var hue:=float(index%8)/8.0
    var base:=Color.from_hsv(hue,0.48,0.92)
    if e.monster_id=="moss_hopper":
        e.attach_visual(Factory.make_slime(e,Color("#75c77d")))
    elif e.monster_id=="leaf_spark":
        e.attach_visual(Factory.make_moth(e,Color("#63e9c6")))
    elif e.monster_id=="crystal_stagling":
        e.attach_visual(Factory.make_crystal_monster(e,Color("#81ded0")))
    elif e.monster_id=="root_guardian":
        e.attach_visual(Factory.make_golem(e,Color("#456b58"),Color("#9cf4d8")))
    elif str(e.monster_id).begins_with("vesper_") or e.monster_id in ["wandering_coral","pearl_crab","tide_spirit","abyssal_sentinel"]:
        e.attach_visual(_make_vesper_enemy_visual(e,str(e.monster_id)))
    elif str(e.monster_id).begins_with("aurelio_") or e.monster_id in ["sun_disk_scarab","mirage_duplicator","dune_watch","hourglass_wisp","oasis_guardian"]:
        e.attach_visual(_make_aurelio_enemy_visual(e,str(e.monster_id)))
    elif str(e.monster_id).begins_with("prism_") or e.monster_id in ["living_gear","copper_sentinel","unstable_automaton","magnetic_guardian","mechanical_core"]:
        e.attach_visual(_make_ferrumia_enemy_visual(e,str(e.monster_id)))
    elif str(e.monster_id).begins_with("snowflake_") or e.monster_id in ["boreal_fox","erratic_crystal","blizzard_spirit","frost_guardian","aurora_sentinel"]:
        e.attach_visual(_make_ivern_enemy_visual(e,str(e.monster_id)))
    elif str(e.monster_id).begins_with("shapeless_") or e.monster_id in ["eclipse_butterfly","mirror_guardian","fractured_shadow","wandering_illusion","silence_watch"]:
        e.attach_visual(_make_umbral_enemy_visual(e,str(e.monster_id)))
    elif e.monster_id in ["memory_warden","tide_echo","gear_echo","frost_echo","root_echo","hour_echo"]:
        e.attach_visual(_make_nexus_echo_visual(e,str(e.monster_id)))
    elif behavior in ["flying","orbit"]:e.attach_visual(Factory.make_moth(e,base))
    elif behavior in ["guardian","shielded","knockback"]:e.attach_visual(Factory.make_golem(e,base,Color("#e9fcff")))
    elif behavior in ["berserker","crusher"]:e.attach_visual(Factory.make_colossus(e,base,Color("#ffd86b")))
    elif behavior in ["sniper","ranged","turret"]:e.attach_visual(Factory.make_crystal_monster(e,base))
    elif behavior in ["assassin","stealth","teleporter"]:e.attach_visual(Factory.make_hound(e,base))
    else:e.attach_visual(Factory.make_slime(e,base))

func _make_nexus_echo_visual(parent:Node3D,monster_id:String)->Node3D:
    var visual:=Node3D.new()
    parent.add_child(visual)
    var palette:Color=Color("#c4a3ff")
    match monster_id:
        "tide_echo":palette=Color("#54d8d0")
        "gear_echo":palette=Color("#ffab75")
        "frost_echo":palette=Color("#a9dcff")
        "root_echo":palette=Color("#86d09a")
        "hour_echo":palette=Color("#ffd17e")
    Factory.make_crystal_monster(visual,palette.darkened(0.18))
    Factory.make_crystal(visual,Vector3(0,1.95,0.12),palette)
    Factory.torus(visual,0.48,0.56,Vector3(0,0.9,0),palette.lightened(0.12))
    return visual

func _make_archive_zero_visual(parent:Node3D)->Node3D:
    var visual:=Node3D.new()
    parent.add_child(visual)
    Factory.box(visual,Vector3(1.8,2.4,1.2),Vector3(0,1.5,0),Color("#34384f"))
    Factory.make_crystal(visual,Vector3(0,1.65,-0.68),Color("#c6a0ff"))
    for i in range(8):
        var angle:=TAU*float(i)/8.0
        var plate:=Factory.box(visual,Vector3(0.42,1.7,0.24),Vector3(cos(angle)*1.55,1.45,sin(angle)*1.55),Color("#6d628d").lerp(Color("#54c9df"),float(i%2)*0.35))
        plate.rotation.y=-angle
        var point:=Factory.sphere(visual,0.14,Vector3(cos(angle)*1.55,2.5,sin(angle)*1.55),Color("#f0d7ff"))
    Factory.torus(visual,1.85,2.02,Vector3(0,0.75,0),Color("#cb9aff"))
    Factory.torus(visual,1.25,1.38,Vector3(0,2.35,0),Color("#66d8ec"))
    return visual

func _make_umbral_enemy_visual(parent:Node3D,monster_id:String)->Node3D:
    var visual:=Node3D.new()
    parent.add_child(visual)
    match monster_id:
        "shapeless_echo":
            var body:=Factory.sphere(visual,0.5,Vector3(0,0.95,0),Color("#706282"))
            body.scale=Vector3(0.76,1.25,0.64)
            Factory.torus(visual,0.36,0.45,Vector3(0,0.76,0),Color("#db95ec"))
            Factory.sphere(visual,0.12,Vector3(-0.18,1.16,-0.34),Color("#f7d7ff"))
            Factory.sphere(visual,0.12,Vector3(0.18,1.16,-0.34),Color("#f7d7ff"))
        "eclipse_butterfly":
            Factory.make_moth(visual,Color("#a87acb"))
            Factory.sphere(visual,0.2,Vector3(0,1.3,-0.35),Color("#ff9edb"))
        "mirror_guardian":
            Factory.make_golem(visual,Color("#655978"),Color("#f0b4ee"))
            for side in [-1.0,1.0]:
                var plate:=Factory.box(visual,Vector3(0.12,1.6,0.95),Vector3(side*0.85,1.1,0),Color("#c3b2d8"))
                plate.rotation.z=side*0.16
        "fractured_shadow":
            Factory.make_hound(visual,Color("#423852"))
            Factory.make_crystal(visual,Vector3(0.45,0.92,0),Color("#dc8bec"))
            Factory.sphere(visual,0.24,Vector3(-0.52,0.8,0.1),Color("#8b70aa"))
        "wandering_illusion":
            var body:=Factory.sphere(visual,0.48,Vector3(0,0.96,0),Color("#7b628e"))
            body.scale=Vector3(0.62,1.22,0.65)
            var echo:=Factory.sphere(visual,0.34,Vector3(0.58,0.78,0.1),Color("#cd9cda"))
            echo.scale=Vector3(0.62,1.0,0.62)
        "silence_watch":
            Factory.make_crystal_monster(visual,Color("#55516e"))
            Factory.torus(visual,0.46,0.54,Vector3(0,1.3,0),Color("#d99be8"))
            Factory.sphere(visual,0.18,Vector3(0,1.72,-0.42),Color("#f5c4e5"))
    return visual

func _make_ivern_enemy_visual(parent:Node3D,monster_id:String)->Node3D:
    var visual:=Node3D.new()
    parent.add_child(visual)
    match monster_id:
        "snowflake_wisp":
            Factory.make_crystal(visual,Vector3(0,0.9,0),Color("#d9f3ff"))
            for i in range(3):
                var ray:=Factory.box(visual,Vector3(0.16,1.25,0.16),Vector3(0,0.95,0),Color("#80d8ed"))
                ray.rotation.z=TAU*float(i)/3.0
        "boreal_fox":
            var body:=Factory.sphere(visual,0.48,Vector3(0,0.78,0),Color("#b5cedf"))
            body.scale=Vector3(0.85,0.72,1.35)
            Factory.sphere(visual,0.33,Vector3(0,1.05,-0.42),Color("#eff7ff"))
            for side in [-1.0,1.0]:
                var ear:=Factory.box(visual,Vector3(0.18,0.5,0.16),Vector3(side*0.22,1.43,-0.48),Color("#8e82bb"))
                ear.rotation.z=side*0.16
                Factory.sphere(visual,0.07,Vector3(side*0.12,1.08,-0.72),Color("#f9dc9a"))
            var tail:=Factory.sphere(visual,0.28,Vector3(0.32,0.7,0.52),Color("#d6eaff"))
            tail.scale=Vector3(0.65,0.7,1.6)
        "erratic_crystal":
            Factory.make_crystal_monster(visual,Color("#8bb9d6"))
            Factory.make_crystal(visual,Vector3(0.65,1.4,0.05),Color("#d4b9ff"))
        "blizzard_spirit":
            var core:=Factory.sphere(visual,0.48,Vector3(0,1.15,0),Color("#a5c8e0"))
            core.scale=Vector3(0.68,1.3,0.68)
            for i in range(3):Factory.torus(visual,0.42+float(i)*0.12,0.49+float(i)*0.12,Vector3(0,0.75+float(i)*0.38,0),Color("#c8ddf4").lerp(Color("#c198e2"),float(i)*0.35))
        "frost_guardian":
            Factory.make_golem(visual,Color("#687f9e"),Color("#d5f1ff"))
            Factory.make_crystal(visual,Vector3(0,2.25,0.22),Color("#a9ddf7"))
        "aurora_sentinel":
            Factory.make_crystal_monster(visual,Color("#7686ad"))
            for side in [-1.0,1.0]:
                var fin:=Factory.box(visual,Vector3(0.22,1.05,0.28),Vector3(side*0.74,1.28,0),Color("#d3a7e8"))
                fin.rotation.z=side*0.32
            Factory.torus(visual,0.42,0.49,Vector3(0,1.8,0),Color("#f1e5bd"))
    return visual

func _make_ferrumia_enemy_visual(parent:Node3D,monster_id:String)->Node3D:
    var visual:=Node3D.new()
    parent.add_child(visual)
    match monster_id:
        "prism_drone":
            Factory.box(visual,Vector3(0.92,0.44,0.74),Vector3(0,1.05,0),Color("#66547b"))
            Factory.make_crystal(visual,Vector3(0,1.5,0),Color("#67e3f5"))
            for side in [-1.0,1.0]:Factory.torus(visual,0.22,0.30,Vector3(side*0.68,1.05,0),Color("#ff8bc7"))
        "living_gear":
            var ring:=Factory.torus(visual,0.33,0.52,Vector3(0,0.78,0),Color("#bd8663"))
            ring.rotation.x=0.0
            for i in range(6):
                var angle:=TAU*float(i)/6.0
                var tooth:=Factory.box(visual,Vector3(0.27,0.32,0.3),Vector3(cos(angle)*0.57,0.78,sin(angle)*0.57),Color("#f4bc72"))
                tooth.rotation.y=-angle
            Factory.sphere(visual,0.2,Vector3(0,0.82,0),Color("#dc77bc"))
        "copper_sentinel":
            Factory.make_golem(visual,Color("#936650"),Color("#75ddf4"))
            Factory.box(visual,Vector3(1.7,0.92,0.26),Vector3(0,1.15,-0.64),Color("#d19263"))
        "unstable_automaton":
            Factory.make_crystal_monster(visual,Color("#68547a"))
            Factory.sphere(visual,0.24,Vector3(0,1.85,0),Color("#ff7fc4"))
            Factory.torus(visual,0.5,0.59,Vector3(0,0.9,0),Color("#68daf4"))
        "magnetic_guardian":
            Factory.make_colossus(visual,Color("#5b506c"),Color("#ff8bc7"))
            Factory.torus(visual,0.82,0.95,Vector3(0,1.35,0),Color("#63dff1"))
        "mechanical_core":
            var core:=Factory.sphere(visual,0.50,Vector3(0,1.15,0),Color("#f18bbd"))
            core.scale=Vector3(1.0,0.82,0.9)
            for i in range(4):
                var blade:=Factory.box(visual,Vector3(0.18,0.75,0.20),Vector3(0,1.16,-0.64),Color("#9c879e"))
                blade.rotation.y=TAU*float(i)/4.0
            Factory.sphere(visual,0.15,Vector3(0,1.18,-0.42),Color("#e6fcff"))
    return visual

func _make_aurelio_enemy_visual(parent:Node3D,monster_id:String)->Node3D:
    var visual:=Node3D.new()
    parent.add_child(visual)
    match monster_id:
        "aurelio_crystal":
            Factory.make_crystal(visual,Vector3(0,1.0,0),Color("#ffd582"))
            Factory.torus(visual,0.38,0.47,Vector3(0,0.8,0),Color("#f2a678"))
            Factory.sphere(visual,0.12,Vector3(-0.18,1.55,-0.18),Color("#fff2c7"))
        "sun_disk_scarab":
            var shell:=Factory.sphere(visual,0.66,Vector3(0,0.72,0),Color("#c87e45"))
            shell.scale=Vector3(1.1,0.62,1.35)
            Factory.torus(visual,0.52,0.64,Vector3(0,0.92,0),Color("#ffd278"))
            for side in [-1.0,1.0]:
                for leg in range(3):
                    var limb:=Factory.cylinder(visual,0.06,0.10,0.62,Vector3(side*0.54,0.37,0.36-float(leg)*0.35),Color("#765246"))
                    limb.rotation.z=side*0.6
        "mirage_duplicator":
            var body:=Factory.sphere(visual,0.55,Vector3(0,0.94,0),Color("#b17b9b"))
            body.scale=Vector3(0.82,1.18,0.72)
            Factory.sphere(visual,0.20,Vector3(-0.2,1.15,-0.36),Color("#ffe0ae"))
            Factory.sphere(visual,0.20,Vector3(0.2,1.15,-0.36),Color("#ffe0ae"))
            var echo:=Factory.sphere(visual,0.36,Vector3(0.62,0.8,0.08),Color("#f6c884"))
            echo.scale=Vector3(0.68,0.92,0.62)
        "dune_watch":
            Factory.make_crystal_monster(visual,Color("#cc9560"))
            Factory.torus(visual,0.42,0.49,Vector3(0,1.05,0),Color("#ffe19b"))
        "hourglass_wisp":
            Factory.torus(visual,0.38,0.48,Vector3(0,1.0,0),Color("#9f84df"))
            Factory.torus(visual,0.38,0.48,Vector3(0,1.55,0),Color("#ffcf81"))
            var core:=Factory.sphere(visual,0.36,Vector3(0,1.28,0),Color("#ead7ff"))
            core.scale=Vector3(0.68,1.25,0.68)
            Factory.cylinder(visual,0.07,0.18,0.95,Vector3(0,1.28,0),Color("#8a6ab8"))
        "oasis_guardian":
            Factory.make_golem(visual,Color("#537b63"),Color("#d9e99a"))
            Factory.sphere(visual,0.42,Vector3(0,2.1,0.24),Color("#4cbdad"))
            Factory.make_crystal(visual,Vector3(0,2.45,0.28),Color("#ffe08b"))
    return visual

func _make_vesper_enemy_visual(parent:Node3D,monster_id:String)->Node3D:
    var visual:=Node3D.new()
    parent.add_child(visual)
    match monster_id:
        "bubble_jumper":
            var body:=Factory.sphere(visual,0.68,Vector3(0,0.72,0),Color("#55d8e6"))
            body.scale=Vector3(1.0,0.80,0.94)
            Factory.torus(visual,0.48,0.58,Vector3(0,0.20,0),Color("#ff9c88"))
            Factory.sphere(visual,0.10,Vector3(-0.22,0.85,-0.48),Color.WHITE)
            Factory.sphere(visual,0.10,Vector3(0.22,0.85,-0.48),Color.WHITE)
            Factory.sphere(visual,0.045,Vector3(-0.22,0.85,-0.55),Color("#202833"))
            Factory.sphere(visual,0.045,Vector3(0.22,0.85,-0.55),Color("#202833"))
        "wandering_coral":
            Factory.sphere(visual,0.50,Vector3(0,0.45,0),Color("#dc796f"))
            for i in range(5):
                var side:float=-1.0 if i%2==0 else 1.0
                var branch:=Factory.cylinder(visual,0.08,0.14,0.95+float(i%3)*0.18,Vector3(side*float(i%3)*0.2,0.95+float(i%3)*0.14,0),Color("#ff9b8d") if i%2==0 else Color("#63d8ce"))
                branch.rotation.z=side*0.30
        "astral_jelly":
            var bell:=Factory.sphere(visual,0.56,Vector3(0,1.28,0),Color("#62c9f2"))
            bell.scale=Vector3(1.25,0.72,1.0)
            Factory.sphere(visual,0.13,Vector3(-0.23,1.34,-0.43),Color("#ffe3a8"))
            Factory.sphere(visual,0.13,Vector3(0.23,1.34,-0.43),Color("#ffe3a8"))
            for x in [-0.36,-0.12,0.12,0.36]:
                var tentacle:=Factory.cylinder(visual,0.035,0.07,0.72,Vector3(x,0.64,0),Color("#da8bd9"))
                tentacle.rotation.z=x*0.35
        "pearl_crab":
            var shell:=Factory.sphere(visual,0.70,Vector3(0,0.78,0),Color("#466d85"))
            shell.scale=Vector3(1.25,0.62,1.05)
            Factory.sphere(visual,0.20,Vector3(-0.70,0.70,-0.12),Color("#f29c87"))
            Factory.sphere(visual,0.20,Vector3(0.70,0.70,-0.12),Color("#f29c87"))
            for side in [-1.0,1.0]:
                for leg in range(3):
                    var limb:=Factory.cylinder(visual,0.06,0.09,0.65,Vector3(side*(0.48+float(leg)*0.14),0.35,0.18-float(leg)*0.28),Color("#d9ac99"))
                    limb.rotation.z=side*0.65
            Factory.sphere(visual,0.13,Vector3(-0.20,1.24,-0.35),Color("#fff1d3"))
            Factory.sphere(visual,0.13,Vector3(0.20,1.24,-0.35),Color("#fff1d3"))
        "tide_spirit":
            Factory.cylinder(visual,0.08,0.42,1.35,Vector3(0,0.80,0),Color("#43c9ba"))
            var crest:=Factory.sphere(visual,0.46,Vector3(0,1.72,0),Color("#64d4d0"))
            crest.scale=Vector3(0.8,1.1,0.8)
            Factory.torus(visual,0.52,0.63,Vector3(0,0.48,0),Color("#b6fff2"))
            Factory.sphere(visual,0.11,Vector3(-0.18,1.78,-0.35),Color("#fff5dc"))
            Factory.sphere(visual,0.11,Vector3(0.18,1.78,-0.35),Color("#fff5dc"))
        "abyssal_sentinel":
            Factory.make_golem(visual,Color("#263e5b"),Color("#ff9989"))
            Factory.make_crystal(visual,Vector3(0,2.20,0.25),Color("#56d8dd"))
            for side in [-1.0,1.0]:
                var fin:=Factory.box(visual,Vector3(0.22,1.15,0.62),Vector3(side*0.92,1.55,0.20),Color("#3b6374"))
                fin.rotation.z=side*0.28
    return visual

func _spawn_position(index:int)->Vector3:
    var angle:=float(index)*2.39996
    var radius:=7.0+float(index%5)*1.6
    return player.position+Vector3(cos(angle)*radius,0,sin(angle)*radius)

func _spawn_boss(id:String)->void:
    var boss_scene:PackedScene=load("res://scenes/bosses/PhaseBoss.tscn")
    var b:Node3D=boss_scene.instantiate() if boss_scene else BossScript.new()
    add_child(b)
    b.position=player.position+Vector3(0,0,-10)
    var boss_map:=str(state.data.get("world",{}).get("map_id","nimbara"))
    if not maps.maps.has(boss_map):boss_map="nimbara"
    b.configure_boss(id,player,content,maps.difficulty(boss_map),state.difficulty_profile())
    if id=="crystal_stag":b.attach_visual(Factory.make_crystal_stag(b,Color("#416a80"),Color("#70f5dc")))
    elif id=="archive_zero":b.attach_visual(_make_archive_zero_visual(b))
    else:
        var palette:Dictionary={
            "fire":[Color("#783b38"),Color("#ffad4d")],
            "wind":[Color("#426c6a"),Color("#83e8dc")],
            "ice":[Color("#4b6380"),Color("#bfeaff")],
            "shadow":[Color("#3e354b"),Color("#d68af0")],
            "gravity":[Color("#50466f"),Color("#ffb6e4")],
            "light":[Color("#6b5d83"),Color("#ffe48c")],
            "thunder":[Color("#485378"),Color("#69dfff")],
            "nature":[Color("#496847"),Color("#b8ed83")],
            "water":[Color("#3c607a"),Color("#69e2df")]
        }
        var colors:Array=palette.get(str(content.BOSSES[id].get("element","gravity")),palette["gravity"])
        b.attach_visual(Factory.make_colossus(b,colors[0],colors[1]))
    b.phase_changed.connect(func(p:int):
        hud.set_mode("CHEFE • FASE %d"%p)
        if is_instance_valid(b):b.scale=Vector3.ONE*(1.0 if p==1 else (1.12 if p==2 else 1.24))
        vfx.boss_phase(self,b.position,Color("#ff6bd6"))
    )
    b.summon_requested.connect(func(k:String,n:int):
        for j in range(n):_spawn_enemy(enemies.size()+j,k)
    )
    b.projectile_requested.connect(_shot)
    b.area_requested.connect(_boss_area)
    b.telegraph_requested.connect(_boss_telegraph)
    b.defeated.connect(_boss_down)
    boss=b

func _enemy_summon(monster_id:String,count:int)->void:
    for i in range(mini(count,perf.max_enemies()-enemies.size())):
        _spawn_enemy(enemies.size()+i,monster_id)

func _enemy_area(center:Vector3,radius:float,damage:float)->void:
    if player.position.distance_to(center)<=radius:
        take_enemy_damage(damage)
    vfx.skill_burst(self,center,Color("#ff8c70"))

func _boss_area(center:Vector3,radius:float,damage:float)->void:
    if player.position.distance_to(center)<=radius:
        take_enemy_damage(damage)
    vfx.boss_phase(self,center,Color("#ff6bd6"))

func _boss_telegraph(center:Vector3,radius:float,damage:float,windup:float)->void:
    vfx.telegraph_circle(self,center,radius,windup)
    get_tree().create_timer(windup).timeout.connect(func():
        if not is_instance_valid(boss) or boss.hp<=0.0:return
        _boss_area(center,radius,damage)
    )

func _shot(origin:Vector3,target:Vector3,damage:float)->void:
    var p:=Node3D.new()
    add_child(p)
    p.position=origin
    Factory.sphere(p,0.20,Vector3.ZERO,Color("#ff79db"))
    p.set_meta("v",(target-origin).normalized()*9.0)
    p.set_meta("d",damage)
    shots.append(p)

func _enemy_down(e:Node3D,x:int)->void:
    _gain_supreme_charge(8.0)
    var monster_id:=str(e.monster_id)
    state.increment_stat("kills")
    progression.award_xp(x)
    var drop:Dictionary=loot.roll(monster_id,str(portal_service.destination),int(state.get_hunter()["level"]),events.multiplier())
    inventory.record_loot(drop)
    var collected:Dictionary=drop.get("items",{})
    for item_id in collected.keys():
        quests.add_collect(str(item_id),int(collected[item_id]))
    daily.add("daily_kills",1)
    director.record_kill()
    quests.add_kill(monster_id,1)
    vfx.death(self,e.position,Color("#a7d7ff"))
    if is_instance_valid(e):enemies.erase(e);e.queue_free()
    if mode=="EXPEDITION":
        activity_progress+=1
        var map_id:=str(portal_service.destination)
        hud.set_mode("EXPEDIÇÃO • %s • %d/%d"%[maps.get_map(map_id)["name"],activity_progress,activity_goal])
        if activity_progress>=activity_goal:
            activity_remaining=0.0
            state.data["world"]["completed_expeditions"]=int(state.data["world"]["completed_expeditions"])+1
            hud.set_mode("EXPEDIÇÃO CONCLUÍDA • "+str(maps.get_map(map_id)["name"]))
            _clear_combat()

func _boss_down(b:Node3D,x:int)->void:
    _gain_supreme_charge(18.0)
    state.increment_stat("bosses")
    progression.award_xp(roundi(float(x)*events.multiplier()))
    quests.add_boss(str(b.boss_id))
    quests.add_rift()
    daily.add("daily_rift",1)
    director.record_rift()
    var drop:Dictionary=loot.roll("aether_slime",str(portal_service.destination),int(state.get_hunter()["level"]),events.multiplier()*2.0)
    inventory.record_loot(drop)
    vfx.boss_phase(self,b.position,Color("#ff6bd6"))
    if is_instance_valid(b):b.queue_free()
    boss=null
    activity_progress=1
    activity_remaining=0.0
    hud.clear_boss()
    hud.set_mode("RIFT CONCLUÍDO • RECOMPENSAS • "+loot.describe(drop))
    audio.level_up()

func _quest_started(id:String)->void:
    if not id.begins_with("nimbara_0") and not id.begins_with("aurelio_0"):return
    var q:Dictionary=quests.get_quest(id)
    var line:=str(q.get("start_dialogue",""))
    if line.is_empty():return
    call_deferred("_show_local_quest_dialogue",str(q.get("title",id)),str(q.get("speaker","Kaien Arashi")),line)

func _quest_completed(id:String)->void:
    var q:Dictionary=quests.get_quest(id)
    if not q.is_empty():
        if q.has("completion_dialogue"):
            call_deferred("_show_local_quest_dialogue",str(q.get("title",id)),str(q.get("speaker","Kaien Arashi")),str(q["completion_dialogue"]))
        elif id.begins_with("nimbara_side_"):
            call_deferred("_show_local_quest_dialogue",str(q.get("title",id)),str(q.get("speaker","Liora")),str(q.get("completion_dialogue","A clareira agradece.")))
        else:
            hud.set_mode("OBJETIVO CONCLUÍDO • "+str(q.get("title",id)))
    if id.begins_with("chapter_") or id.begins_with("boss_"):
        _story()
    if id=="nimbara_08":
        state.data["story"]["flags"]["nimbara_slice_complete"]=true
        save.save_now()
        hud.set_mode("ÂNCORA ESTABILIZADA • CAPÍTULO NIMBARA CONCLUÍDO")
        quests.start("aurelio_01")
        call_deferred("_enter_hq")
    elif id=="aurelio_08":
        state.data["story"]["flags"]["aurelio_slice_complete"]=true
        save.save_now()
        hud.set_mode("SEGUNDA ÂNCORA ESTABILIZADA • CAPÍTULO AURÉLIO CONCLUÍDO")
        call_deferred("_enter_hq")

func _nearest(radius:float)->Node3D:
    var best:Node3D=null
    var best_distance:=radius
    for e in enemies:
        if is_instance_valid(e):
            var distance:=e.position.distance_to(player.position)
            if distance<best_distance:
                best_distance=distance
                best=e
    if boss and is_instance_valid(boss) and boss.position.distance_to(player.position)<best_distance:
        best=boss
    return best

func _dodge()->void:
    if not dodge_ready or dead_timer>0.0:return
    dodge_ready=false
    invulnerability=0.48
    if player.has_method("play_dodge"):player.play_dodge()
    var direction:Vector2=hud.move_vector if hud and hud.move_vector.length_squared()>0.01 else Input.get_vector("move_left","move_right","move_forward","move_back")
    if direction.length_squared()<0.01:direction=Vector2(0,-1)
    direction=direction.normalized()
    var move:=Vector3(direction.x,0,direction.y)
    var next:=player.position+move*3.2
    var map_id:=str(portal_service.destination)
    if mode=="EXPEDITION" and maps.blocked(map_id,next,0.6):
        next=player.position
    player.position=next
    vfx.dodge_trail(self,player.position,move)
    get_tree().create_timer(1.0).timeout.connect(func():dodge_ready=true)

func take_enemy_damage(d:float)->void:
    if invulnerability>0.0 or dead_timer>0.0:return
    var h:Dictionary=state.get_hunter()
    var dodge:=clampf(_core("dodge")+skill_tree.bonus("dodge"),0.0,0.70)
    if randf()<dodge:return
    h["hp"]=maxf(0.0,float(h["hp"])-d)
    if player.has_method("play_hurt"):player.play_hurt()
    vfx.hit_burst(self,player.position+Vector3(0,0.8,0),Color("#ff7185"))
    if float(h["hp"])<=0.0:
        state.increment_stat("deaths")
        dead_timer=1.0
        if player.has_method("play_death"):player.play_death()
        get_tree().create_timer(dead_timer).timeout.connect(_respawn_player)

func _respawn_player()->void:
    if not is_instance_valid(player):return
    var h:Dictionary=state.get_hunter()
    h["hp"]=h["max_hp"]
    player.position=Vector3(0,0.1,6)
    if player.has_method("respawn"):player.respawn()
    dead_timer=0.0

func _clear_combat()->void:
    for e in enemies:
        if is_instance_valid(e):e.queue_free()
    enemies.clear()
    if boss and is_instance_valid(boss):boss.queue_free()
    boss=null
    for p in shots:
        if is_instance_valid(p):p.queue_free()
    shots.clear()

func _story()->void:
    if side_dialogue_active:
        if not local_dialogue_queue.is_empty():
            _present_next_local_dialogue(true)
        elif cutscene and cutscene.is_active():
            cutscene.hide_cutscene()
        return
    if not story.has_next_line():
        if cutscene and cutscene.is_active():cutscene.hide_cutscene()
        hud.set_mode("HISTÓRIA • CENA CONCLUÍDA")
        if not local_dialogue_queue.is_empty():call_deferred("_present_next_local_dialogue")
        return
    var line:Dictionary=story.next_line()
    if cutscene and is_instance_valid(cutscene):
        cutscene.show_line(story.chapter_title(),str(line["character"]),str(line["text"]))
    hud.set_mode("HISTÓRIA • "+str(line["character"]))

func _wardrobe()->void:
    if content.STYLES.is_empty():return
    var unlocked:Array=state.data["wardrobe"]["unlocked"]
    var next_index:int=unlocked.size()%content.STYLES.size()
    var next_id:=str(content.STYLES[next_index]["id"])
    if next_id not in unlocked:
        unlocked.append(next_id)
    wardrobe.select(next_id)
    _set_player()
    hud.set_mode("ARMÁRIO • %d/%d ESTILOS"%[unlocked.size(),content.STYLES.size()])

func _core(kind:String)->float:
    return cores.bonus(kind)+float(skill_tree.bonus(kind))

func _process(delta:float)->void:
    if cutscene and cutscene.is_active():return
    _tick_supreme(delta)
    if activity_remaining>0.0:
        activity_remaining=maxf(0.0,activity_remaining-delta)
        if activity_remaining<=0.0:
            if mode=="EXPEDITION":
                hud.set_mode("EXPEDIÇÃO ENCERRADA • %d/%d"%[activity_progress,activity_goal])
            elif mode=="VERSUS":
                hud.set_mode("VERSUS ENCERRADO • %d/%d"%[activity_progress,activity_goal])
    clock=fmod(clock+delta,600.0)
    state.data["world"]["day_clock"]=clock
    invulnerability=maxf(0.0,invulnerability-delta)
    damage_buff_time=maxf(0.0,damage_buff_time-delta)
    if damage_buff_time<=0.0:damage_buff=0.0
    events.tick(delta)
    director.tick(delta)
    state.data["statistics"]["play_seconds"]=float(state.data["statistics"].get("play_seconds",0.0))+delta

    var h:Dictionary=state.get_hunter()
    h["energy"]=minf(float(h["max_energy"]),float(h["energy"])+delta*4.5)

    var v:Vector2=hud.move_vector if hud and hud.move_vector.length_squared()>0.01 else Input.get_vector("move_left","move_right","move_forward","move_back")
    if v.length_squared()>0.001 and dead_timer<=0.0:
        v=v.limit_length(1.0)
        var step:=Vector3(v.x,0,v.y)*6.2*delta
        var next:=player.position+step
        if mode=="EXPEDITION" and maps.blocked(str(portal_service.destination),next,0.62):
            next=player.position
        player.position=next
        player.position.x=clampf(player.position.x,-25,25)
        player.position.z=clampf(player.position.z,-25,25)
    if player.has_method("set_locomotion"):player.set_locomotion(v)
    if dead_timer<=0.0 and player.has_method("play_run") and v.length_squared()>0.001:
        player.play_run()
    elif dead_timer<=0.0 and player.has_method("play_idle") and v.length_squared()<=0.001:
        player.play_idle()

    var camera_target:=player.position+Vector3(14,20,14)
    camera.position=camera.position.lerp(camera_target,1.0-exp(-10.0*delta))
    camera.look_at(player.position+Vector3(0,1,0),Vector3.UP)

    if boss and is_instance_valid(boss):
        hud.set_boss(str(boss.boss_stats.get("name","CHEFE")),boss.get_hp_ratio(),int(boss.phase))
    elif hud:
        hud.clear_boss()

    for i in range(shots.size()-1,-1,-1):
        var p:=shots[i]
        if not is_instance_valid(p):
            shots.remove_at(i)
            continue
        p.position+=Vector3(p.get_meta("v"))*delta
        if p.position.distance_to(player.position)<0.9:
            take_enemy_damage(float(p.get_meta("d")))
            p.queue_free()
            shots.remove_at(i)

    if world.sun:
        var wave:=sin(clock/600.0*TAU)*0.5+0.5
        world.sun.rotation_degrees.x=lerpf(-66,-12,wave)
        world.sun.light_energy=lerpf(0.35,1.25,wave)

func _notification(what:int)->void:
    if what==NOTIFICATION_WM_CLOSE_REQUEST:
        save.force_save_and_flush()
        get_tree().quit()

func _apply_quality(profile:Dictionary)->void:
    if perf and get_viewport():
        perf.apply(get_viewport(),world)
    if vfx and "max_pool" in vfx:
        vfx.max_pool=12 if str(profile.get("name",""))=="LOW" else (18 if str(profile.get("name",""))=="MEDIUM" else 24)
