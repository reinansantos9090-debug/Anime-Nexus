extends SceneTree
## Headless regression suite for the offline gameplay core.
## Exit code 0 means all assertions passed.

const StateScript=preload("res://scripts/core/game_state.gd")
const CombatScript=preload("res://scripts/gameplay/combat_service.gd")
const LootScript=preload("res://scripts/gameplay/loot_service.gd")
const ContentScript=preload("res://scripts/core/content_database.gd")
const SaveScript=preload("res://scripts/core/save_service.gd")
const JoystickScript=preload("res://scripts/ui/virtual_joystick.gd")
const GameRootScript=preload("res://scripts/game_root.gd")
const EnemyScript=preload("res://scripts/gameplay/enemy_agent.gd")
const BossScript=preload("res://scripts/gameplay/boss_agent.gd")
const MapScript=preload("res://scripts/world/map_service.gd")
const WorldScript=preload("res://scripts/world/world_service.gd")
const SkillTreeScript=preload("res://scripts/gameplay/skill_tree_service.gd")
const QuestScript=preload("res://scripts/gameplay/quest_service.gd")

var failures:Array[String]=[]

func _init()->void:
    var game_root=GameRootScript.new()
    _expect(game_root!=null,"Runtime: main game root script must parse and instantiate")
    if game_root:game_root.free()
    _test_xp()
    _test_damage()
    _test_loot()
    _test_save()
    _test_virtual_joystick()
    _test_nimbara_vertical_slice_data_and_quest()
    _test_static_field_slow()
    if failures.is_empty():
        print("ANIME_NEXUS_TESTS: PASS")
        quit(0)
    else:
        for item in failures:push_error(item)
        print("ANIME_NEXUS_TESTS: FAIL %d"%failures.size())
        quit(1)

func _expect(condition:bool,message:String)->void:
    if not condition:failures.append(message)

func _test_xp()->void:
    var state=StateScript.new()
    state.reset()
    var before=int(state.data["hunter"]["level"])
    state.add_xp(120)
    _expect(int(state.data["hunter"]["level"])==before+1,"XP: level did not advance")
    _expect(int(state.data["progression"]["skill_points"])==1,"XP: level did not award skill point")

func _test_damage()->void:
    var state=StateScript.new()
    state.reset()
    var combat=CombatScript.new()
    combat.setup(state,null)
    var damage:=combat.player_damage({"damage":100.0},1,0.0,0.0)
    _expect(damage>=100.0 and damage<=175.0,"Damage: formula outside expected range")
    
func _test_loot()->void:
    var state=StateScript.new()
    state.reset()
    var content=ContentScript.new()
    var loot=LootScript.new()
    loot.setup(state,content)
    var drop:Dictionary=loot.roll("aether_slime","verdant_frontier",1,1.0)
    _expect(not str(drop.get("rarity","")).is_empty(),"Loot: missing rarity")
    _expect(int(drop.get("gold",0))>0,"Loot: missing gold")
    _expect(not drop.get("items",{}).is_empty(),"Loot: missing item")

func _test_save()->void:
    var state=StateScript.new()
    state.reset()
    state.data["hunter"]["gold"]=9876
    var save=SaveScript.new()
    save.setup(state)
    save.configure_paths("user://anime_nexus_test_save.json","user://anime_nexus_test_save.bak.json")
    _expect(save.save_now(),"Save: could not write save")
    state.data["hunter"]["gold"]=1
    _expect(save.load_now(),"Save: could not reload save")
    _expect(int(state.data["hunter"]["gold"])==9876,"Save: persisted value mismatch")
    save.free()
    state.free()
    DirAccess.remove_absolute(ProjectSettings.globalize_path("user://anime_nexus_test_save.json"))
    DirAccess.remove_absolute(ProjectSettings.globalize_path("user://anime_nexus_test_save.bak.json"))

func _test_virtual_joystick()->void:
    var stick=JoystickScript.new()
    stick.size=Vector2(180,180)
    stick._update_vector(Vector2(90,90))
    _expect(stick.vector==Vector2.ZERO,"Joystick: center must be neutral")
    stick._update_vector(Vector2(180,90))
    _expect(stick.vector.x>0.99 and absf(stick.vector.y)<0.01,"Joystick: full horizontal input mismatch")
    stick._update_vector(Vector2(0,0))
    _expect(is_equal_approx(stick.vector.length(),1.0),"Joystick: diagonal input must clamp to unit length")
    stick.free()

func _test_nimbara_vertical_slice_data_and_quest()->void:
    var state=StateScript.new()
    state.reset()
    var content=ContentScript.new()
    var maps=MapScript.new()
    maps._ready()
    _expect(state.data["hunter"]["name"]=="Kaien Arashi","Slice: default playable character must be Kaien")
    _expect(state.data["loadout"]["weapon"]=="fulgor_gauntlets","Slice: Kaien loadout mismatch")
    _expect(maps.get_map("nimbara")["name"].begins_with("Nimbara"),"Slice: Nimbara map data missing")
    _expect(content.MONSTERS.has("moss_hopper") and content.MONSTERS.has("leaf_spark"),"Slice: Nimbara creatures missing")
    _expect(content.BOSSES.has("crystal_stag"),"Slice: Cérvido de Cristal boss data missing")
    for ability_id in ["lightning_step","sky_chain","static_field"]:
        _expect(content.ABILITIES.has(ability_id),"Slice: Kaien ability missing: "+ability_id)
    var quests=QuestScript.new()
    quests.setup(state,content)
    quests.start("nimbara_01")
    for i in range(4):quests.add_kill("moss_hopper")
    _expect("nimbara_01" in state.data["quests"]["completed"],"Slice: Nimbara mission did not complete at four kills")
    _expect("nimbara_02" in state.data["quests"]["active"],"Slice: Cérvido mission did not unlock")
    quests.add_boss("crystal_stag")
    _expect("nimbara_02" in state.data["quests"]["completed"],"Slice: boss mission did not complete")
    _expect("nimbara_03" in state.data["quests"]["active"],"Slice: anchor mission did not unlock after boss")
    quests.add_interaction("resonance_anchor")
    _expect("nimbara_03" in state.data["quests"]["completed"],"Slice: anchor interaction did not complete the prologue")
    state.free()
    content.free()
    maps.free()
    quests.free()

func _test_static_field_slow()->void:
    var content=ContentScript.new()
    var enemy=EnemyScript.new()
    enemy.configure("moss_hopper",null,content)
    var normal_speed:float=enemy._speed()
    enemy.apply_slow(3.0,0.42)
    _expect(enemy._speed()<normal_speed*0.45,"Combat: static-field slow did not reduce enemy movement")
    enemy.apply_slow(2.0,0.01)
    _expect(is_equal_approx(enemy.slow_factor,0.15),"Combat: slow factor must respect its safe lower bound")
    enemy.free()
    content.free()
