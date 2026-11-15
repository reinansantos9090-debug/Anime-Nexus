extends Node3D
## Offline companion prototype. C++ decides combat state and damage; this node
## handles local movement, target lookup, and presentation.

const Factory=preload("res://scripts/visuals/stylized_factory.gd")

var owner_actor:Node3D
var combat_service:Node
var game_state:Node
var native_core:AnimeNexusCombatCore
var companion_id:=""
var display_name:=""
var element:="fire"
var role:="assault"
var body_color:=Color("#a9433c")
var accent_color:=Color("#ffb64a")
var formation_offset:=Vector3(-2.1,0.0,2.3)
var combat_active:=false
var attack_cooldown:=0.0
var skill_cooldown:=0.0
var move_speed:=4.1
var state_name:="follow"
var title_tag:Label3D

func configure(owner:Node3D,combat:Node,state:Node,id:String,title:String,element_id:String,role_id:String,
        body:Color,accent:Color,offset:Vector3)->void:
    owner_actor=owner
    combat_service=combat
    game_state=state
    companion_id=id
    display_name=title
    element=element_id
    role=role_id
    body_color=body
    accent_color=accent
    formation_offset=offset
    native_core=AnimeNexusCombatCore.new()
    name=id
    global_position=owner.global_position+offset
    Factory.make_hunter(self,body_color,accent_color,Color("#edc19c"))
    title_tag=Label3D.new()
    title_tag.text=display_name
    title_tag.font_size=18
    title_tag.outline_size=5
    title_tag.position=Vector3(0,2.55,0)
    add_child(title_tag)

func set_combat_active(active:bool)->void:
    combat_active=active

func reset_formation()->void:
    if is_instance_valid(owner_actor):
        global_position=owner_actor.global_position+formation_offset

func _process(delta:float)->void:
    if not is_instance_valid(owner_actor):return
    attack_cooldown=maxf(0.0,attack_cooldown-delta)
    skill_cooldown=maxf(0.0,skill_cooldown-delta)
    var owner_distance:=global_position.distance_to(owner_actor.global_position)
    if owner_distance>24.0:
        reset_formation()
        owner_distance=global_position.distance_to(owner_actor.global_position)
    var target:=_nearest_target(7.0) if combat_active else null
    var enemy_distance:=global_position.distance_to(target.global_position) if target else -1.0
    var hunter:Dictionary=game_state.get_hunter() if game_state else {}
    var hp_ratio:=float(hunter.get("hp",1.0))/maxf(1.0,float(hunter.get("max_hp",1.0)))
    var decision:Dictionary=native_core.companion_decision(owner_distance,enemy_distance,hp_ratio)
    state_name=str(decision.get("state","follow"))
    if target and (state_name=="attack" or (state_name=="guard" and enemy_distance<=2.6)):
        _attack_target(target)
    else:
        _follow_owner(delta,float(decision.get("speed_multiplier",1.0)))

func _nearest_target(radius:float)->Node3D:
    var tree:=get_tree()
    if tree==null:return null
    var nearest:Node3D=null
    var best_distance:=radius
    for candidate in tree.get_nodes_in_group("enemy_agents"):
        if not is_instance_valid(candidate) or not (candidate is Node3D):continue
        if candidate.has_method("get_hp_ratio") and float(candidate.get_hp_ratio())<=0.0:continue
        var enemy:=candidate as Node3D
        var distance:=global_position.distance_to(enemy.global_position)
        if distance<best_distance:
            nearest=enemy
            best_distance=distance
    return nearest

func _attack_target(target:Node3D)->void:
    var direction:=target.global_position-global_position
    direction.y=0.0
    if direction.length_squared()>0.01:look_at(global_position+direction,Vector3.UP)
    var nearby_count:=_count_targets(3.8)
    if skill_cooldown<=0.0 and nearby_count>=2:
        _use_resonance_skill(target.global_position)
        skill_cooldown=9.0
    elif attack_cooldown<=0.0:
        var hunter:Dictionary=game_state.get_hunter() if game_state else {}
        var level:=int(hunter.get("level",1))
        var role_multiplier:=1.0 if role=="assault" else 0.82
        var damage:=native_core.companion_damage(13.0,level,role_multiplier)
        combat_service.hit(target,damage,false,element)
        attack_cooldown=1.45 if role=="assault" else 1.75

func _use_resonance_skill(center:Vector3)->void:
    var radius:=4.0
    var hunter:Dictionary=game_state.get_hunter() if game_state else {}
    var damage:=native_core.companion_damage(19.0,int(hunter.get("level",1)),1.0)
    var tree:=get_tree()
    if tree==null:return
    for candidate in tree.get_nodes_in_group("enemy_agents"):
        if not is_instance_valid(candidate) or not (candidate is Node3D):continue
        var enemy:=candidate as Node3D
        if enemy.has_method("get_hp_ratio") and float(enemy.get_hp_ratio())<=0.0:continue
        if enemy.global_position.distance_to(center)>radius:continue
        combat_service.hit(enemy,damage,false,element)
        if role=="controller" and enemy.has_method("apply_slow"):
            enemy.apply_slow(2.2,0.55)

func _count_targets(radius:float)->int:
    var tree:=get_tree()
    if tree==null:return 0
    var count:=0
    for candidate in tree.get_nodes_in_group("enemy_agents"):
        if not is_instance_valid(candidate) or not (candidate is Node3D):continue
        if candidate.has_method("get_hp_ratio") and float(candidate.get_hp_ratio())<=0.0:continue
        if global_position.distance_to((candidate as Node3D).global_position)<=radius:
            count+=1
    return count

func _follow_owner(delta:float,speed_multiplier:float)->void:
    var offset:=formation_offset
    if state_name=="guard":offset=Vector3(-formation_offset.x,0.0,-1.5)
    var destination:=owner_actor.global_position+owner_actor.global_basis*offset
    destination.y=owner_actor.global_position.y
    var direction:=destination-global_position
    direction.y=0.0
    var distance:=direction.length()
    if distance<=0.38:return
    direction/=distance
    global_position+=direction*move_speed*speed_multiplier*delta
    look_at(global_position+direction,Vector3.UP)

func info()->Dictionary:
    return {"id":companion_id,"name":display_name,"element":element,"role":role,"state":state_name}
