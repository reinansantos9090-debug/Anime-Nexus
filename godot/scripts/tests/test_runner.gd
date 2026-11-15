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
const CompanionScript=preload("res://scripts/gameplay/companion_agent.gd")
const BossScript=preload("res://scripts/gameplay/boss_agent.gd")
const MapScript=preload("res://scripts/world/map_service.gd")
const WorldScript=preload("res://scripts/world/world_service.gd")
const SkillTreeScript=preload("res://scripts/gameplay/skill_tree_service.gd")
const QuestScript=preload("res://scripts/gameplay/quest_service.gd")
const InventoryScript=preload("res://scripts/gameplay/inventory_service.gd")
const StoryScript=preload("res://scripts/gameplay/story_service.gd")

var failures:Array[String]=[]

func _init()->void:
    var game_root=GameRootScript.new()
    _expect(game_root!=null,"Runtime: main game root script must parse and instantiate")
    if game_root:game_root.free()
    _test_xp()
    _test_damage()
    _test_native_combat_core()
    _test_supreme_meter()
    _test_companion_agent_setup()
    _test_elemental_reaction_runtime()
    _test_loot()
    _test_weapon_workshop()
    _test_save()
    _test_save_slots()
    _test_virtual_joystick()
    _test_nimbara_vertical_slice_data_and_quest()
    _test_aurelio_campaign_chain()
    _test_story_dialogue_completion()
    _test_vesper_region_data()
    _test_vesper_campaign_chain()
    _test_aurelio_region_data()
    _test_ferrumia_region_data()
    _test_ferrumia_campaign_chain()
    _test_ivern_region_data()
    _test_ivern_campaign_chain()
    _test_umbral_region_data()
    _test_umbral_campaign_chain()
    _test_nexus_region_data()
    _test_nexus_final_campaign_chain()
    _test_prologue_and_epilogue_routes()
    _test_regional_boss_catalog()
    _test_boss_telegraph()
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

func _test_native_combat_core()->void:
    var core=AnimeNexusCombatCore.new()
    var normal:Dictionary=core.calculate_damage(100.0,1,0.2,0.5,0.7)
    var critical:Dictionary=core.calculate_damage(100.0,3,0.2,0.5,0.2)
    _expect(is_equal_approx(float(normal["amount"]),120.0),"C++ combat: normal damage formula mismatch")
    _expect(not bool(normal["critical"]),"C++ combat: non-critical roll was marked critical")
    _expect(absf(float(critical["amount"])-((100.0+5.0)*1.2*1.75))<0.001,"C++ combat: critical damage formula mismatch")
    _expect(bool(critical["critical"]),"C++ combat: critical roll was not marked critical")
    var chain:Dictionary=core.resolve_elemental_reaction("thunder","water")
    _expect(str(chain["id"])=="conductive_chain" and float(chain["radius"])>0.0,"C++ combat: thunder/water reaction missing")
    _expect(is_equal_approx(float(chain["splash_multiplier"]),0.35) and int(chain["max_targets"])==3,"C++ combat: conductive-chain policy mismatch")
    var reverse:Dictionary=core.resolve_elemental_reaction("water","thunder")
    _expect(str(reverse["id"])==str(chain["id"]),"C++ combat: reaction must be order-independent")
    var ember:Dictionary=core.resolve_elemental_reaction("fire","wind")
    var frost:Dictionary=core.resolve_elemental_reaction("ice","wind")
    var lunar:Dictionary=core.resolve_elemental_reaction("moon","nature")
    var prism:Dictionary=core.resolve_elemental_reaction("light","shadow")
    var singularity:Dictionary=core.resolve_elemental_reaction("gravity","fire")
    _expect(float(ember["splash_multiplier"])>0.0 and int(ember["max_targets"])>0,"C++ combat: ember-storm policy missing")
    _expect(float(frost["slow_duration"])>0.0 and float(frost["slow_factor"])<1.0,"C++ combat: frost-mist policy missing")
    _expect(float(lunar["heal_ratio"])>0.0,"C++ combat: lunar-bloom healing policy missing")
    _expect(float(prism["splash_multiplier"])>0.0 and int(prism["max_targets"])>0,"C++ combat: prism-echo policy missing")
    _expect(str(singularity["id"])=="resonance_singularity" and float(singularity["pull_strength"])>0.0,"C++ combat: gravity combination policy missing")
    var follow:Dictionary=core.companion_decision(4.0,-1.0,1.0)
    var attack:Dictionary=core.companion_decision(4.0,3.0,1.0)
    var regroup:Dictionary=core.companion_decision(18.0,1.0,1.0)
    var guard:Dictionary=core.companion_decision(4.0,1.0,0.15)
    _expect(str(follow["state"])=="follow","C++ companion: follow decision mismatch")
    _expect(str(attack["state"])=="attack","C++ companion: attack decision mismatch")
    _expect(str(regroup["state"])=="regroup","C++ companion: leash recovery decision mismatch")
    _expect(str(guard["state"])=="guard","C++ companion: low-health guard decision mismatch")
    _expect(is_equal_approx(core.companion_damage(10.0,3,1.2),13.08),"C++ companion: role/level damage formula mismatch")
    var hunter:Dictionary={"level":1,"xp":0,"xp_to_next":120,"hp":140,"max_hp":140,"max_energy":100.0}
    var progression:Dictionary={"skill_points":0}
    var level_result:Dictionary=core.advance_experience(hunter,progression,300)
    _expect(int(level_result["level"])==3 and int(level_result["xp"])==25,"C++ progression: level carry-over mismatch")
    _expect(int(level_result["levels_gained"])==2 and int(level_result["skill_points"])==2,"C++ progression: level reward mismatch")
    _expect(int(level_result["hp"])==164 and is_equal_approx(float(level_result["max_energy"]),108.0),"C++ progression: level stat growth mismatch")
    
func _test_supreme_meter()->void:
    var core=AnimeNexusCombatCore.new()
    var half:Dictionary=core.resolve_supreme_meter(0.0,42.5,false)
    _expect(is_equal_approx(float(half["charge"]),42.5) and not bool(half["ready"]),"Supreme: partial charge mismatch")
    var cap:Dictionary=core.resolve_supreme_meter(97.0,12.0,false)
    _expect(is_equal_approx(float(cap["charge"]),100.0) and bool(cap["ready"]),"Supreme: meter did not clamp at full charge")
    var denied:Dictionary=core.resolve_supreme_meter(99.0,0.0,true)
    _expect(not bool(denied["activated"]) and is_equal_approx(float(denied["charge"]),99.0),"Supreme: activation below full charge was accepted")
    var used:Dictionary=core.resolve_supreme_meter(100.0,0.0,true)
    _expect(bool(used["activated"]) and is_equal_approx(float(used["charge"]),0.0),"Supreme: ready activation did not consume charge")
    core.free()

func _test_elemental_reaction_runtime()->void:
    var state=StateScript.new()
    state.reset()
    var content=ContentScript.new()
    var enemy=EnemyScript.new()
    enemy.configure("aether_slime",null,content)
    var combat=CombatScript.new()
    combat.setup(state,null)
    var result:Dictionary=combat.hit(enemy,10.0,false,"thunder")
    _expect(str(result.get("reaction",{}).get("id",""))=="conductive_chain","Combat: thunder/water reaction did not trigger")
    _expect(is_equal_approx(float(result.get("amount",0.0)),11.5),"Combat: elemental reaction multiplier was not applied")
    _expect(is_equal_approx(enemy.hp,enemy.max_hp-11.5),"Combat: reaction damage did not reach the enemy")
    enemy.free()
    combat.free()
    content.free()
    state.free()

func _test_companion_agent_setup()->void:
    var state=StateScript.new()
    state.reset()
    var owner:=Node3D.new()
    var combat=CombatScript.new()
    combat.setup(state,null)
    var companion=CompanionScript.new()
    companion.configure(owner,combat,state,"akari_solen","Akari","fire","assault",
        Color("#9e3940"),Color("#ffb34d"),Vector3(-2,0,2))
    _expect(str(companion.info().get("element",""))=="fire","Companion: Akari element was not configured")
    _expect(str(companion.info().get("role",""))=="assault","Companion: assault role was not configured")
    _expect(companion.title_tag.text=="Akari","Companion: visible identity tag missing")
    _expect(companion.get_child(0).get_child_count()>=8,"Companion: Akari identity blockout accessories were not built")
    companion.free()
    state.data["hunter"]["hp"]=50.0
    state.data["hunter"]["energy"]=10.0
    var support=CompanionScript.new()
    support.configure(owner,combat,state,"yuna_tsukari","Yuna","moon","support",
        Color("#514272"),Color("#e7d3ff"),Vector3(2,0,2))
    support._support_owner()
    _expect(is_equal_approx(float(state.data["hunter"]["hp"]),78.0),"Companion: local support pulse did not restore health")
    _expect(is_equal_approx(float(state.data["hunter"]["energy"]),22.0),"Companion: support pulse did not restore energy")
    _expect(str(support.info().get("state",""))=="support","Companion: support action state missing")
    support.free()
    combat.free()
    owner.free()
    state.free()

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

func _test_weapon_workshop()->void:
    var state=StateScript.new()
    state.reset()
    var content=ContentScript.new()
    var inventory=InventoryScript.new()
    inventory.setup(state)
    var available:Array[String]=inventory.available_weapons(content)
    _expect("fulgor_gauntlets" in available and not ("volt_blades" in available),"Workshop: only the starting instrument should be available initially")
    _expect(inventory.craft_by_id("forge_volt_blades",content),"Workshop: affordable unique instrument project failed")
    _expect(inventory.quantity("aether_core")==6 and inventory.quantity("plasma_fiber")==2,"Workshop: instrument materials were not debited atomically")
    _expect(inventory.quantity("weapon_license_volt_blades")==1,"Workshop: crafting did not persist the instrument license in inventory")
    available=inventory.available_weapons(content)
    _expect("volt_blades" in available and not ("toxic_bow" in available),"Workshop: Arsenal unlock list does not match owned licenses")
    var after:Dictionary=state.get_inventory().duplicate(true)
    _expect(not inventory.craft_by_id("forge_volt_blades",content),"Workshop: duplicate unique instrument project was allowed")
    _expect(state.get_inventory()==after,"Workshop: duplicate project changed inventory after rejection")
    inventory.free()
    content.free()
    state.free()

func _test_save()->void:
    var state=StateScript.new()
    state.reset()
    state.data["hunter"]["gold"]=9876
    state.data["hunter"]["chaos_energy"]=65.0
    var save=SaveScript.new()
    save.setup(state)
    save.configure_paths("user://anime_nexus_test_save.json","user://anime_nexus_test_save.bak.json")
    _expect(save.save_now(),"Save: could not write save")
    _expect(not FileAccess.file_exists("user://anime_nexus_test_save.json.tmp"),"Save: temporary file was left after a successful write")
    state.data["hunter"]["gold"]=1
    _expect(save.save_now(),"Save: could not rotate the previous valid save to backup")
    var damaged:=FileAccess.open("user://anime_nexus_test_save.json",FileAccess.WRITE)
    if damaged:
        damaged.store_string("{ incomplete json")
        damaged.close()
    else:
        _expect(false,"Save: could not create the corrupt-primary recovery fixture")
    state.data["hunter"]["gold"]=2
    _expect(save.load_now(),"Save: could not reload save")
    _expect(int(state.data["hunter"]["gold"])==9876,"Save: corrupt primary did not recover the previous backup")
    _expect(is_equal_approx(float(state.data["hunter"].get("chaos_energy",0.0)),65.0),"Save: supreme meter was not persisted locally")
    _expect(state.apply_loaded({"schema":4,"hunter":{"gold":444},"settings":"invalid","story":{"flags":[],"journal":"invalid"}}),"Save: supported old schema was rejected")
    _expect(int(state.data["schema"])==8 and int(state.data["hunter"]["gold"])==444,"Save: older schema did not migrate while preserving progress")
    _expect(state.data["party"]["companions"].size()==2,"Save: migration did not restore the default local companion roster")
    _expect(not bool(state.data["world"].get("nexus_core_unlocked",false)),"Save: legacy data must not unlock the final campaign region")
    _expect(str(state.data["settings"]["difficulty"])=="adventure" and is_equal_approx(float(state.data["settings"]["camera_zoom"]),24.0),"Save: old schema did not receive current settings defaults")
    _expect(state.data["story"]["flags"] is Dictionary and bool(state.data["story"]["flags"]["rooftop_unlocked"]),"Save: malformed legacy section replaced default story flags")
    _expect(state.data["story"]["journal"] is Array,"Save: malformed legacy journal replaced the current default list")
    var future:=FileAccess.open("user://anime_nexus_test_save.json",FileAccess.WRITE)
    if future:
        future.store_string(JSON.stringify({"schema":999,"hunter":{"gold":999}}))
        future.close()
    else:
        _expect(false,"Save: could not create future-schema recovery fixture")
    _expect(save.load_now(),"Save: newer incompatible primary did not fall back to the compatible backup")
    _expect(int(state.data["hunter"]["gold"])==9876,"Save: newer schema data was loaded over the supported backup")
    DirAccess.remove_absolute(ProjectSettings.globalize_path("user://anime_nexus_test_save.json"))
    DirAccess.remove_absolute(ProjectSettings.globalize_path("user://anime_nexus_test_save.bak.json"))
    var interrupted:=FileAccess.open("user://anime_nexus_test_save.json.tmp",FileAccess.WRITE)
    if interrupted:
        interrupted.store_string(JSON.stringify({"schema":8,"hunter":{"gold":333}}))
        interrupted.close()
    else:
        _expect(false,"Save: could not create interrupted-write recovery fixture")
    _expect(save.load_now(),"Save: completed temporary write was not recovered")
    _expect(int(state.data["hunter"]["gold"])==333,"Save: temporary recovery loaded the wrong progress")
    _expect(not FileAccess.file_exists("user://anime_nexus_test_save.json.tmp"),"Save: recovered temporary file was not finalized")
    save.free()
    state.free()
    DirAccess.remove_absolute(ProjectSettings.globalize_path("user://anime_nexus_test_save.json"))
    DirAccess.remove_absolute(ProjectSettings.globalize_path("user://anime_nexus_test_save.bak.json"))
    DirAccess.remove_absolute(ProjectSettings.globalize_path("user://anime_nexus_test_save.json.tmp"))

func _test_save_slots()->void:
    var state=StateScript.new()
    state.reset()
    var save=SaveScript.new()
    save.setup(state)
    var paths:Array=["user://anime_nexus_test_slot_1.json","user://anime_nexus_test_slot_2.json","user://anime_nexus_test_slot_3.json"]
    save.configure_slot_paths(paths)
    state.data["hunter"]["gold"]=111
    _expect(save.save_slot(0),"Save slots: could not write slot 1")
    state.data["hunter"]["gold"]=222
    _expect(save.save_slot(1),"Save slots: could not write slot 2")
    state.data["hunter"]["gold"]=333
    _expect(not bool(save.slot_summary(2).get("has_save",false)),"Save slots: empty slot 3 should remain empty")
    _expect(save.load_slot(0),"Save slots: could not load slot 1")
    _expect(int(state.data["hunter"]["gold"])==111,"Save slots: slot 1 data was overwritten by slot 2")
    _expect(save.load_slot(1),"Save slots: could not load slot 2")
    _expect(int(state.data["hunter"]["gold"])==222,"Save slots: slot 2 data mismatch")
    var future_slot:=FileAccess.open(paths[2],FileAccess.WRITE)
    if future_slot:
        future_slot.store_string(JSON.stringify({"schema":999,"hunter":{"gold":999}}))
        future_slot.close()
    else:
        _expect(false,"Save slots: could not create future-version slot")
    _expect(bool(save.slot_summary(2).get("future_schema",false)),"Save slots: future-version slot was not detected")
    _expect(not save.save_slot(2),"Save slots: overwrite of future-version save was allowed")
    _expect(int(save._read(paths[2]).get("schema",0))==999,"Save slots: future-version save was overwritten")
    save.free()
    state.free()
    for path in paths:
        DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
        DirAccess.remove_absolute(ProjectSettings.globalize_path(str(path)+".bak"))
        DirAccess.remove_absolute(ProjectSettings.globalize_path(str(path)+".tmp"))

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
    _expect(content.COMPANIONS.size()==7 and content.COMPANIONS.has("yuna_tsukari"),"Slice: original ally roster or local support profile missing")
    for ally_id in content.COMPANIONS.keys():
        var ally:Dictionary=content.COMPANIONS[ally_id]
        _expect(float(ally.get("skill_radius",0.0))>0.0 and float(ally.get("skill_cooldown",0.0))>0.0,"Slice: ally lacks an authored local skill profile: "+str(ally_id))
    _expect(content.MONSTERS.has("moss_hopper") and content.MONSTERS.has("leaf_spark"),"Slice: Nimbara creatures missing")
    _expect(content.BOSSES.has("crystal_stag"),"Slice: Cérvido de Cristal boss data missing")
    for ability_id in ["lightning_step","sky_chain","static_field"]:
        _expect(content.ABILITIES.has(ability_id),"Slice: Kaien ability missing: "+ability_id)
    var quests=QuestScript.new()
    quests.setup(state,content)
    quests.start("nimbara_01")
    quests.start("nimbara_01")
    _expect(state.data["quests"]["active"].count("nimbara_01")==1,"Slice: starting an active quest must not duplicate it")
    for i in range(4):quests.add_kill("moss_hopper")
    _expect("nimbara_01" in state.data["quests"]["completed"],"Slice: Nimbara mission did not complete at four kills")
    _expect("nimbara_02" in state.data["quests"]["active"],"Slice: Cérvido mission did not unlock")
    _expect(int(state.data["inventory"].get("nimbara_pollen",0))==3,"Slice: mission pollen reward was not granted")
    var pollen_after_completion:int=int(state.data["inventory"].get("nimbara_pollen",0))
    quests.add_kill("moss_hopper")
    quests.start("nimbara_01")
    _expect(int(state.data["inventory"].get("nimbara_pollen",0))==pollen_after_completion,"Slice: completed mission reward was duplicated")
    for i in range(3):quests.add_kill("leaf_spark")
    _expect("nimbara_02" in state.data["quests"]["completed"] and "nimbara_03" in state.data["quests"]["active"],"Slice: second Nimbara mission did not chain")
    for i in range(3):quests.add_collect("memory_bloom")
    _expect("nimbara_03" in state.data["quests"]["completed"] and "nimbara_04" in state.data["quests"]["active"],"Slice: crystal-trail collection did not chain")
    quests.add_map("nimbara")
    _expect("nimbara_04" in state.data["quests"]["completed"] and "nimbara_05" in state.data["quests"]["active"],"Slice: return-to-clearing objective did not chain")
    quests.add_kill("root_guardian")
    _expect("nimbara_05" in state.data["quests"]["completed"] and "nimbara_06" in state.data["quests"]["active"],"Slice: guardian objective did not chain")
    for i in range(3):quests.add_interaction("memory_echo")
    _expect("nimbara_06" in state.data["quests"]["completed"] and "nimbara_07" in state.data["quests"]["active"],"Slice: lake-memory objective did not chain")
    quests.add_boss("crystal_stag")
    _expect("nimbara_07" in state.data["quests"]["completed"] and "nimbara_08" in state.data["quests"]["active"],"Slice: Cérvido mission did not unlock the anchor")
    quests.add_interaction("resonance_anchor")
    _expect("nimbara_08" in state.data["quests"]["completed"],"Slice: anchor interaction did not complete the chapter")
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

func _test_vesper_region_data()->void:
    var maps=MapScript.new()
    var content=ContentScript.new()
    var vesper:Dictionary=maps.get_map("vesper")
    var enemies:Array=vesper.get("enemies",[])
    _expect(str(vesper.get("name","")).begins_with("Vesper"),"Vesper: expedition map metadata missing")
    _expect(enemies.size()==6,"Vesper: expected six distinct local encounter species")
    _expect(not vesper.get("obstacles",[]).is_empty(),"Vesper: local route obstacles missing")
    for enemy_id in enemies:
        _expect(content.MONSTERS.has(enemy_id),"Vesper: encounter has no offline monster definition: "+str(enemy_id))
        if content.MONSTERS.has(enemy_id):
            for item_id in content.MONSTERS[enemy_id].get("loot",[]):
                _expect(content.ITEMS.has(item_id),"Vesper: creature loot has no local item definition: "+str(item_id))
    maps.free()
    content.free()

func _test_aurelio_region_data()->void:
    var maps=MapScript.new()
    var content=ContentScript.new()
    var aurelio:Dictionary=maps.get_map("aurelio")
    var enemies:Array=aurelio.get("enemies",[])
    _expect(str(aurelio.get("name","")).begins_with("Aurélio"),"Aurélio: expedition map metadata missing")
    _expect(enemies.size()==6,"Aurélio: expected six local encounter species")
    for enemy_id in enemies:
        _expect(content.MONSTERS.has(enemy_id),"Aurélio: local monster definition missing: "+str(enemy_id))
        if content.MONSTERS.has(enemy_id):
            for item_id in content.MONSTERS[enemy_id].get("loot",[]):
                _expect(content.ITEMS.has(item_id),"Aurélio: local loot item missing: "+str(item_id))
    maps.free()
    content.free()

func _test_ferrumia_region_data()->void:
    var maps=MapScript.new()
    var content=ContentScript.new()
    var ferrumia:Dictionary=maps.get_map("ferrumia")
    var enemies:Array=ferrumia.get("enemies",[])
    _expect(str(ferrumia.get("name","")).begins_with("Ferrúmia"),"Ferrúmia: expedition map metadata missing")
    _expect(enemies.size()==6,"Ferrúmia: expected six local encounter species")
    for enemy_id in enemies:
        _expect(content.MONSTERS.has(enemy_id),"Ferrúmia: local monster definition missing: "+str(enemy_id))
        if content.MONSTERS.has(enemy_id):
            for item_id in content.MONSTERS[enemy_id].get("loot",[]):
                _expect(content.ITEMS.has(item_id),"Ferrúmia: local loot item missing: "+str(item_id))
    maps.free()
    content.free()

func _test_ivern_region_data()->void:
    var maps=MapScript.new()
    var content=ContentScript.new()
    var ivern:Dictionary=maps.get_map("ivern")
    var enemies:Array=ivern.get("enemies",[])
    _expect(str(ivern.get("name","")).begins_with("Ivern"),"Ivern: expedition map metadata missing")
    _expect(enemies.size()==6,"Ivern: expected six local encounter species")
    for enemy_id in enemies:
        _expect(content.MONSTERS.has(enemy_id),"Ivern: local monster definition missing: "+str(enemy_id))
        if content.MONSTERS.has(enemy_id):
            for item_id in content.MONSTERS[enemy_id].get("loot",[]):
                _expect(content.ITEMS.has(item_id),"Ivern: local loot item missing: "+str(item_id))
    maps.free()
    content.free()

func _test_umbral_region_data()->void:
    var maps=MapScript.new()
    var content=ContentScript.new()
    var umbral:Dictionary=maps.get_map("umbral")
    var enemies:Array=umbral.get("enemies",[])
    _expect(str(umbral.get("name","")).begins_with("Umbral"),"Umbral: expedition map metadata missing")
    _expect(enemies.size()==6,"Umbral: expected six local encounter species")
    for enemy_id in enemies:
        _expect(content.MONSTERS.has(enemy_id),"Umbral: local monster definition missing: "+str(enemy_id))
        if content.MONSTERS.has(enemy_id):
            for item_id in content.MONSTERS[enemy_id].get("loot",[]):
                _expect(content.ITEMS.has(item_id),"Umbral: local loot item missing: "+str(item_id))
    maps.free()
    content.free()

func _test_nexus_region_data()->void:
    var maps=MapScript.new()
    var content=ContentScript.new()
    var nexus:Dictionary=maps.get_map("nexus_core")
    var enemies:Array=nexus.get("enemies",[])
    _expect(str(nexus.get("name","")).begins_with("Núcleo do Nexo"),"Nexus: final-region expedition metadata missing")
    _expect(enemies.size()==6,"Nexus: expected six local memory echoes")
    _expect(content.BOSSES.has("archive_zero"),"Nexus: Archive Zero boss definition missing")
    var archive:Dictionary=content.BOSSES.get("archive_zero",{})
    _expect(archive.get("patterns",[]).size()>=4,"Nexus: Archive Zero needs several authored attack patterns")
    _expect(float(archive.get("phase2_ratio",0.0))>float(archive.get("phase3_ratio",0.0)),"Nexus: Archive Zero phase thresholds are out of order")
    _expect(content.MONSTERS.has(str(archive.get("summon_id",""))),"Nexus: boss summon must resolve to local creature data")
    for enemy_id in enemies:
        _expect(content.MONSTERS.has(enemy_id),"Nexus: local echo definition missing: "+str(enemy_id))
        if content.MONSTERS.has(enemy_id):
            for item_id in content.MONSTERS[enemy_id].get("loot",[]):
                _expect(content.ITEMS.has(item_id),"Nexus: local echo loot item missing: "+str(item_id))
    maps.free()
    content.free()

func _test_story_dialogue_completion()->void:
    var state=StateScript.new()
    state.reset()
    var story=StoryScript.new()
    story.setup(state)
    for i in range(8):
        _expect(story.has_next_line(),"Story: original prologue ended before all authored lines")
        story.next_line()
    _expect(not story.has_next_line(),"Story: completed prologue must expose a closed-scene state")
    _expect(str(story.next_line().get("text","")).is_empty(),"Story: exhausted dialogue must not repeat a placeholder line")
    _expect(state.data["story"]["journal"].size()==8,"Story: prologue must save all displayed lines locally")
    story.free()
    state.free()

func _test_vesper_campaign_chain()->void:
    var content=ContentScript.new()
    var maps=MapScript.new()
    maps._ready()
    var expected:Array=["vesper_01","vesper_02","vesper_03","vesper_04","vesper_05","vesper_06","vesper_07","vesper_08"]
    for index in range(expected.size()):
        var found:Dictionary={}
        for quest in content.QUESTS:
            if str(quest.get("id",""))==expected[index]:
                found=quest
                break
        _expect(not found.is_empty(),"Vesper campaign: missing %s"%expected[index])
        if found.is_empty():continue
        _expect(str(found.get("map",""))=="vesper","Vesper campaign: wrong map in %s"%expected[index])
        if str(found.get("type",""))=="kill":
            var target_id:=str(found.get("monster",""))
            _expect(content.MONSTERS.has(target_id),"Vesper campaign: creature missing in %s"%expected[index])
            _expect(target_id in maps.maps["vesper"].get("enemies",[]),
                "Vesper campaign: creature absent from region pool in %s"%expected[index])
        elif str(found.get("type",""))=="collect":
            var item_id:=str(found.get("item",""))
            _expect(content.ITEMS.has(item_id),"Vesper campaign: material missing in %s"%expected[index])
            var drop_available:=false
            for monster_id in maps.maps["vesper"].get("enemies",[]):
                if item_id in content.MONSTERS.get(str(monster_id),{}).get("loot",[]):
                    drop_available=true
                    break
            _expect(drop_available,"Vesper campaign: objective material not dropped in Vesper")
        elif str(found.get("type",""))=="boss":
            _expect(content.BOSSES.has(str(found.get("boss",""))),"Vesper campaign: boss missing")
        if index<expected.size()-1:
            _expect(str(found.get("next",""))==expected[index+1],"Vesper campaign: broken chain at %s"%expected[index])
    _expect(str(content.REGIONAL_BOSSES.get("vesper",""))=="tide_keeper",
        "Vesper campaign: wrong regional boss")
    _expect(str(content.CAMPAIGN_NEXT_QUEST.get("aurelio",""))=="vesper_01",
        "Vesper campaign: chapter must unlock after Aurelio")
    content.free()
    maps.free()

func _test_ivern_campaign_chain()->void:
    var content=ContentScript.new()
    var maps=MapScript.new()
    maps._ready()
    var expected:Array=["ivern_01","ivern_02","ivern_03","ivern_04","ivern_05","ivern_06","ivern_07","ivern_08"]
    for index in range(expected.size()):
        var quest:Dictionary={}
        for row in content.QUESTS:
            if str(row.get("id",""))==expected[index]:
                quest=row
                break
        _expect(not quest.is_empty(),"Ivern campaign: missing %s"%expected[index])
        if quest.is_empty():continue
        _expect(str(quest.get("map",""))=="ivern","Ivern campaign: wrong map")
        var kind:=str(quest.get("type",""))
        if kind=="kill":
            var monster_id:=str(quest.get("monster",""))
            _expect(content.MONSTERS.has(monster_id),"Ivern campaign: missing creature")
            _expect(monster_id in maps.maps["ivern"].get("enemies",[]),"Ivern campaign: creature absent from map")
        elif kind=="collect":
            var item_id:=str(quest.get("item",""))
            _expect(content.ITEMS.has(item_id),"Ivern campaign: missing material")
            var dropped:=false
            for monster_id in maps.maps["ivern"].get("enemies",[]):
                if item_id in content.MONSTERS.get(str(monster_id),{}).get("loot",[]):
                    dropped=true
                    break
            _expect(dropped,"Ivern campaign: objective material unavailable in region")
        elif kind=="boss":
            _expect(content.BOSSES.has(str(quest.get("boss",""))),"Ivern campaign: missing boss")
        if index<expected.size()-1:
            _expect(str(quest.get("next",""))==expected[index+1],"Ivern campaign: broken chain")
    _expect(str(content.REGIONAL_BOSSES.get("ivern",""))=="blizzard_monarch",
        "Ivern campaign: regional boss mismatch")
    _expect(str(content.CAMPAIGN_NEXT_QUEST.get("ferrumia",""))=="ivern_01",
        "Ivern campaign: chapter must unlock after Ferrúmia")
    content.free()
    maps.free()

func _test_umbral_campaign_chain()->void:
    var content=ContentScript.new()
    var maps=MapScript.new()
    maps._ready()
    var expected:Array=["umbral_01","umbral_02","umbral_03","umbral_04","umbral_05","umbral_06","umbral_07","umbral_08"]
    for index in range(expected.size()):
        var quest:Dictionary={}
        for row in content.QUESTS:
            if str(row.get("id",""))==expected[index]:
                quest=row
                break
        _expect(not quest.is_empty(),"Umbral campaign: missing %s"%expected[index])
        if quest.is_empty():continue
        _expect(str(quest.get("map",""))=="umbral","Umbral campaign: wrong map")
        var kind:=str(quest.get("type",""))
        if kind=="kill":
            var target_id:=str(quest.get("monster",""))
            _expect(content.MONSTERS.has(target_id),"Umbral campaign: missing target")
            _expect(target_id in maps.maps["umbral"].get("enemies",[]),"Umbral campaign: target absent from map")
        elif kind=="collect":
            var item_id:=str(quest.get("item",""))
            _expect(content.ITEMS.has(item_id),"Umbral campaign: missing material")
            var dropped:=false
            for monster_id in maps.maps["umbral"].get("enemies",[]):
                if item_id in content.MONSTERS.get(str(monster_id),{}).get("loot",[]):
                    dropped=true
                    break
            _expect(dropped,"Umbral campaign: objective material unavailable in region")
        elif kind=="boss":
            _expect(content.BOSSES.has(str(quest.get("boss",""))),"Umbral campaign: missing boss")
        if index<expected.size()-1:
            _expect(str(quest.get("next",""))==expected[index+1],"Umbral campaign: broken chain")
    _expect(str(content.CAMPAIGN_NEXT_QUEST.get("ivern",""))=="umbral_01","Umbral: chapter link missing")
    _expect(str(content.CAMPAIGN_NEXT_QUEST.get("umbral",""))=="final_01","Umbral: final unlock link missing")
    content.free()
    maps.free()

func _test_nexus_final_campaign_chain()->void:
    var content=ContentScript.new()
    var maps=MapScript.new()
    maps._ready()
    var expected:Array=["final_01","final_02","final_03","final_04","final_05","final_06"]
    for index in range(expected.size()):
        var quest:Dictionary={}
        for row in content.QUESTS:
            if str(row.get("id",""))==expected[index]:
                quest=row
                break
        _expect(not quest.is_empty(),"Final campaign: missing %s"%expected[index])
        if quest.is_empty():continue
        _expect(str(quest.get("map",""))=="nexus_core","Final campaign: wrong map")
        if str(quest.get("type",""))=="boss":
            _expect(str(quest.get("boss",""))=="archive_zero","Final campaign: boss must be Arquivo Zero")
        if str(quest.get("object","")).ends_with("_anchor"):
            _expect(maps.maps["nexus_core"].has("resonance_anchor"),"Final campaign: central anchor has no map position")
        if index<expected.size()-1:
            _expect(str(quest.get("next",""))==expected[index+1],"Final campaign: broken quest chain")
    content.free()
    maps.free()

func _test_prologue_and_epilogue_routes()->void:
    var content=ContentScript.new()
    var maps=MapScript.new()
    maps._ready()
    var expected:Array=["prologue_01","prologue_02","prologue_03","prologue_04","nimbara_01"]
    for index in range(expected.size()):
        var found:Dictionary={}
        for row in content.QUESTS:
            if str(row.get("id",""))==expected[index]:
                found=row
                break
        _expect(not found.is_empty(),"Prologue: missing linked mission %s"%expected[index])
        if index<expected.size()-1 and not found.is_empty():
            _expect(str(found.get("next",""))==expected[index+1],"Prologue: broken next link from %s"%expected[index])
    _expect(str(content.QUESTS[0].get("id",""))=="prologue_01","Prologue: initial new-game objective must begin with story")
    _expect(str(content.BOSSES.get("prism_primordial",{}).get("name",""))=="Prisma Primordial","Epilogue: secret boss is not cataloged")
    _expect(maps.maps.get("nimbara",{}).get("interaction_points",{}).has("prologue_resonator"),"Prologue: Nimbara resonator interaction point missing")
    _expect(maps.maps.get("nexus_core",{}).get("interaction_points",{}).has("observatory_return"),"Epilogue: return beacon interaction point missing")
    var epilogue_rows:Array=[]
    for row in content.QUESTS:
        if str(row.get("id","")) in ["epilogue_01","epilogue_02"]:
            epilogue_rows.append(row)
    _expect(epilogue_rows.size()==2,"Epilogue: both playable missions must be cataloged")
    _expect(str(epilogue_rows[0].get("next",""))=="epilogue_02","Epilogue: return mission must lead into the horizon challenge")
    _expect(bool(epilogue_rows[1].get("optional",false)),"Epilogue: secret boss must not block free expedition selection")
    content.free()
    maps.free()

func _test_ferrumia_campaign_chain()->void:
    var content=ContentScript.new()
    var maps=MapScript.new()
    maps._ready()
    var expected:Array=["ferrumia_01","ferrumia_02","ferrumia_03","ferrumia_04","ferrumia_05","ferrumia_06","ferrumia_07","ferrumia_08"]
    for index in range(expected.size()):
        var quest:Dictionary={}
        for row in content.QUESTS:
            if str(row.get("id",""))==expected[index]:
                quest=row
                break
        _expect(not quest.is_empty(),"Ferrúmia campaign: missing %s"%expected[index])
        if quest.is_empty():continue
        _expect(str(quest.get("map",""))=="ferrumia","Ferrúmia campaign: wrong map")
        var kind:=str(quest.get("type",""))
        if kind=="kill":
            var monster_id:=str(quest.get("monster",""))
            _expect(content.MONSTERS.has(monster_id),"Ferrúmia campaign: missing creature")
            _expect(monster_id in maps.maps["ferrumia"].get("enemies",[]),"Ferrúmia campaign: creature missing from map pool")
        elif kind=="collect":
            var item_id:=str(quest.get("item",""))
            _expect(content.ITEMS.has(item_id),"Ferrúmia campaign: missing objective material")
            var dropped:=false
            for monster_id in maps.maps["ferrumia"].get("enemies",[]):
                if item_id in content.MONSTERS.get(str(monster_id),{}).get("loot",[]):
                    dropped=true
                    break
            _expect(dropped,"Ferrúmia campaign: objective material unavailable in region")
        elif kind=="boss":
            _expect(content.BOSSES.has(str(quest.get("boss",""))),"Ferrúmia campaign: boss catalog entry missing")
        if index<expected.size()-1:
            _expect(str(quest.get("next",""))==expected[index+1],"Ferrúmia campaign: broken quest chain")
    _expect(str(content.REGIONAL_BOSSES.get("ferrumia",""))=="steel_coral_colossus",
        "Ferrúmia campaign: regional boss mismatch")
    _expect(str(content.CAMPAIGN_NEXT_QUEST.get("vesper",""))=="ferrumia_01",
        "Ferrúmia campaign: chapter must unlock after Vesper")
    content.free()
    maps.free()

func _test_aurelio_campaign_chain()->void:
    var content=ContentScript.new()
    var maps=MapScript.new()
    maps._ready()
    var expected:Array=["aurelio_01","aurelio_02","aurelio_03","aurelio_04","aurelio_05","aurelio_06","aurelio_07","aurelio_08"]
    for index in range(expected.size()):
        var found:Dictionary={}
        for quest in content.QUESTS:
            if str(quest.get("id",""))==expected[index]:
                found=quest
                break
        _expect(not found.is_empty(),"Aurélio campaign: missing %s"%expected[index])
        if found.is_empty():continue
        _expect(str(found.get("map",""))=="aurelio","Aurélio campaign: wrong map in %s"%expected[index])
        if str(found.get("type",""))=="kill":
            _expect(content.MONSTERS.has(str(found.get("monster",""))),
                "Aurélio campaign: target creature missing in %s"%expected[index])
        elif str(found.get("type",""))=="collect":
            var item_id:=str(found.get("item",""))
            _expect(content.ITEMS.has(item_id),
                "Aurélio campaign: objective material missing in %s"%expected[index])
            var drop_available:=false
            for monster_id in maps.maps["aurelio"].get("enemies",[]):
                if item_id in content.MONSTERS.get(str(monster_id),{}).get("loot",[]):
                    drop_available=true
                    break
            _expect(drop_available,"Aurélio campaign: objective material is not dropped in its region for %s"%expected[index])
        elif str(found.get("type",""))=="boss":
            _expect(content.BOSSES.has(str(found.get("boss",""))),
                "Aurélio campaign: boss missing in %s"%expected[index])
        if str(found.get("type","")) in ["kill","collect"]:
            _expect(str(found.get("type",""))!="kill" or str(found.get("monster","")) in maps.maps["aurelio"].get("enemies",[]),
                "Aurélio campaign: target not available in map pool for %s"%expected[index])
        _expect(int(found.get("target",0))>0,"Aurélio campaign: missing objective count in %s"%expected[index])
        _expect(not str(found.get("start_dialogue","")).is_empty(),"Aurélio campaign: missing opening line in %s"%expected[index])
        _expect(not str(found.get("completion_dialogue","")).is_empty(),"Aurélio campaign: missing completion line in %s"%expected[index])
        for reward_id in found.get("rewards",{}).keys():
            _expect(content.ITEMS.has(str(reward_id)),
                "Aurélio campaign: reward item missing in %s"%expected[index])
        if index<expected.size()-1:
            _expect(str(found.get("next",""))==expected[index+1],"Aurélio campaign: broken next link in %s"%expected[index])
    _expect(str(content.REGIONAL_BOSSES.get("aurelio",""))=="glass_sphinx",
        "Aurélio campaign: final boss must match regional route")
    _expect(str(content.CAMPAIGN_NEXT_QUEST.get("nimbara",""))=="aurelio_01",
        "Aurélio campaign: chapter must unlock after Nimbara")
    content.free()
    maps.free()

func _test_regional_boss_catalog()->void:
    var content=ContentScript.new()
    var maps=MapScript.new()
    maps._ready()
    for region_id in content.REGIONAL_BOSSES.keys():
        _expect(maps.maps.has(region_id),"Regional boss: map missing for %s"%region_id)
        _expect(content.BOSSES.has(str(content.REGIONAL_BOSSES[region_id])),
            "Regional boss: catalog entry missing for %s"%region_id)
    _expect(str(content.REGIONAL_BOSSES.get("nimbara",""))=="crystal_stag",
        "Regional boss: Nimbara must preserve the campaign Cérvido encounter")
    _expect(str(content.REGIONAL_BOSSES.get("nexus_core",""))=="archive_zero",
        "Regional boss: final region must route to Arquivo Zero")
    content.free()
    maps.free()

func _test_boss_telegraph()->void:
    var boss=BossScript.new()
    var warnings:Array=[]
    var immediate_hits:Array=[]
    boss.telegraph_requested.connect(func(center:Vector3,radius:float,damage:float,windup:float):
        warnings.append({"center":center,"radius":radius,"windup":windup})
    )
    boss.area_requested.connect(func(_center:Vector3,_radius:float,_damage:float):immediate_hits.append(true))
    boss._warn_area(Vector3(1,0,1),3.2,120.0,0.72)
    _expect(warnings.size()==1,"Boss: area attack did not announce its warning telegraph")
    _expect(float(warnings[0].get("windup",0.0))>=0.5,"Boss: area attack warning window is too short")
    _expect(immediate_hits.is_empty(),"Boss: area attack dealt damage before the telegraph resolved")
    boss.free()
