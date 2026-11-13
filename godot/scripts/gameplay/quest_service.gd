extends Node
signal updated
signal completed(quest_id:String)

var game_state:Node
var database:Node
var native_core: AnimeNexusQuestCore

func setup(state:Node,content:Node)->void:
    game_state=state
    database=content
    native_core=AnimeNexusQuestCore.new()

func start(id:String)->void:
    var result:Dictionary=native_core.start_quest(game_state.data["quests"],database.QUESTS,id)
    if bool(result.get("started",false)):
        game_state.data["quests"]=result["quests"]
        game_state.quest_changed.emit()
        updated.emit()

func add_progress(id:String,amount:=1)->void:
    _apply_event("direct",id,amount)

func add_kill(monster_id:String,amount:=1)->void:
    _apply_event("kill",monster_id,amount)

func add_collect(item_id:String,amount:=1)->void:
    _apply_event("collect",item_id,amount)

func add_map(map_id:String)->void:
    _apply_event("map",map_id,1)

func add_interaction(object_id:String)->void:
    _apply_event("interact",object_id,1)

func add_boss(boss_id:String)->void:
    _apply_event("boss",boss_id,1)

func add_rift()->void:
    _apply_event("rift","",1)

func complete(id:String)->void:
    _apply_event("complete",id,1)

func _apply_event(event_type:String,subject_id:String,amount:int)->void:
    if game_state==null or database==null or native_core==null:return
    var result:Dictionary=native_core.apply_event(
        game_state.data["quests"],database.QUESTS,event_type,subject_id,amount)
    if not bool(result.get("changed",false)):return
    game_state.data["quests"]=result["quests"]
    var xp_reward:int=int(result.get("xp_reward",0))
    if xp_reward>0:game_state.add_xp(xp_reward)
    var item_rewards:Dictionary=result.get("items_reward",{})
    for item_id in item_rewards.keys():
        var quantity:int=int(item_rewards[item_id])
        if quantity>0:game_state.add_item(str(item_id),quantity)
    for quest_id in result.get("completed_now",[]):
        completed.emit(str(quest_id))
    game_state.quest_changed.emit()
    updated.emit()

func get_quest(id:String)->Dictionary:
    if database==null:return {}
    for quest in database.QUESTS:
        if str(quest["id"])==id:return quest
    return {}

func active_summary()->String:
    var active:Array=game_state.data["quests"]["active"]
    if active.is_empty():return "Nenhum contrato ativo"
    var id:=str(active[0])
    var quest:=get_quest(id)
    var value:=int(game_state.data["quests"]["progress"].get(id,0))
    return "%s  %d/%d"%[quest.get("title",id),value,int(quest.get("target",1))]
