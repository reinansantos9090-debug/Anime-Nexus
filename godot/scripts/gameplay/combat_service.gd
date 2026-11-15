extends Node
var game_state: Node
var audio_service: Node
var vfx_service: Node
var rng := RandomNumberGenerator.new()
var native_core: AnimeNexusCombatCore

func setup(state: Node, audio: Node, vfx: Node = null) -> void:
    game_state = state
    audio_service = audio
    vfx_service = vfx
    rng.seed = 9917
    native_core = AnimeNexusCombatCore.new()

func player_damage(weapon: Dictionary, level: int, bonus: float, crit_bonus: float) -> float:
    return float(player_attack(weapon, level, bonus, crit_bonus).get("amount", 0.0))

func player_attack(weapon: Dictionary, level: int, bonus: float, crit_bonus: float) -> Dictionary:
    var result := native_core.calculate_damage(
        float(weapon.get("damage",10.0)), level, bonus, 0.08 + crit_bonus, rng.randf())
    return result

func elemental_reaction(element_a: String, element_b: String) -> Dictionary:
    return native_core.resolve_elemental_reaction(element_a, element_b)

func hit(target: Node3D, amount: float, critical := false, attacker_element := "none") -> Dictionary:
    if not is_instance_valid(target) or not target.has_method("take_damage"):
        return {}
    var reaction:Dictionary={"id":"none","damage_multiplier":1.0,"radius":0.0,"status":"none"}
    if attacker_element!="none" and target.has_method("elemental_affinity") and target.has_method("can_trigger_elemental_reaction"):
        if target.can_trigger_elemental_reaction():
            reaction=elemental_reaction(str(attacker_element),str(target.elemental_affinity()))
    var applied_amount:=amount*float(reaction.get("damage_multiplier",1.0))
    target.take_damage(applied_amount,critical)
    if game_state:
        game_state.increment_stat("damage_dealt",applied_amount)
    if str(reaction.get("id","none"))!="none":
        target.begin_elemental_reaction_cooldown()
        _apply_reaction(target,reaction,applied_amount)
    if audio_service:
        audio_service.hit()
    return {"amount":applied_amount,"critical":critical,"reaction":reaction}

func _apply_reaction(target:Node3D,reaction:Dictionary,damage:float)->void:
    var reaction_id:=str(reaction.get("id","none"))
    var radius:=float(reaction.get("radius",0.0))
    var position:=target.global_position
    var effect_parent:=get_parent() as Node3D
    if vfx_service and is_instance_valid(vfx_service) and effect_parent:
        vfx_service.reaction_feedback(effect_parent,position,reaction_id,radius)
    match reaction_id:
        "conductive_chain":
            _splash_nearby(target,radius,damage*float(reaction.get("splash_multiplier",0.0)),int(reaction.get("max_targets",0)))
        "ember_storm":
            _splash_nearby(target,radius+1.0,damage*float(reaction.get("splash_multiplier",0.0)),int(reaction.get("max_targets",0)))
        "frost_mist":
            var slow_duration:=float(reaction.get("slow_duration",0.0))
            var slow_factor:=float(reaction.get("slow_factor",1.0))
            if target.has_method("apply_slow"):target.apply_slow(slow_duration,slow_factor)
            _slow_nearby(target,radius,slow_duration,slow_factor)
        "lunar_bloom":
            if game_state:
                var hunter:Dictionary=game_state.get_hunter()
                var heal_amount:=float(hunter.get("max_hp",1.0))*float(reaction.get("heal_ratio",0.0))
                hunter["hp"]=minf(float(hunter.get("max_hp",1.0)),float(hunter.get("hp",1.0))+heal_amount)
                game_state.state_changed.emit()
        "prism_echo":
            _splash_nearby(target,radius,damage*float(reaction.get("splash_multiplier",0.0)),int(reaction.get("max_targets",0)))
        "resonance_singularity":
            _pull_nearby(target,radius,float(reaction.get("pull_strength",0.0)))

func _splash_nearby(origin:Node3D,radius:float,damage:float,limit:int)->void:
    var tree:=get_tree()
    if tree==null:return
    var affected:=0
    for candidate in tree.get_nodes_in_group("enemy_agents"):
        if not is_instance_valid(candidate) or candidate==origin or not (candidate is Node3D):continue
        var enemy:=candidate as Node3D
        if enemy.global_position.distance_to(origin.global_position)>radius:continue
        if enemy.has_method("get_hp_ratio") and float(enemy.get_hp_ratio())<=0.0:continue
        if enemy.has_method("take_damage"):
            enemy.take_damage(damage,false)
            if game_state:game_state.increment_stat("damage_dealt",damage)
            affected+=1
            if affected>=limit:break

func _slow_nearby(origin:Node3D,radius:float,duration:float,factor:float)->void:
    var tree:=get_tree()
    if tree==null:return
    for candidate in tree.get_nodes_in_group("enemy_agents"):
        if not is_instance_valid(candidate) or candidate==origin or not candidate is Node3D:continue
        var enemy:=candidate as Node3D
        if enemy.global_position.distance_to(origin.global_position)<=radius and enemy.has_method("apply_slow"):
            enemy.apply_slow(duration,factor)

func _pull_nearby(origin:Node3D,radius:float,strength:float)->void:
    var tree:=get_tree()
    if tree==null:return
    for candidate in tree.get_nodes_in_group("enemy_agents"):
        if not is_instance_valid(candidate) or candidate==origin or not candidate is Node3D:continue
        var enemy:=candidate as Node3D
        if enemy.global_position.distance_to(origin.global_position)<=radius:
            enemy.global_position=enemy.global_position.lerp(origin.global_position,strength)

func spawn_impact(parent: Node3D, position: Vector3, color := Color("#ffe16a")) -> void:
    var fx := GPUParticles3D.new()
    fx.amount = 8
    fx.lifetime = 0.3
    fx.one_shot = true
    fx.position = position
    var draw := SphereMesh.new()
    draw.radius = 0.05
    draw.height = 0.1
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    draw.material = material
    fx.draw_pass_1 = draw
    parent.add_child(fx)
    fx.emitting = true
