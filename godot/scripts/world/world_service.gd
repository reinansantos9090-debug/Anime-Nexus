extends Node
## Runtime world builder. Map rules are supplied by map_service.gd; visual
## primitives stay lightweight so authored layouts remain viable on mobile.

const Factory = preload("res://scripts/visuals/stylized_factory.gd")
const GroundShader = preload("res://shaders/biome_ground.gdshader")

var root: Node3D
var database: Node
var map_db: Node
var world_root: Node3D
var portal: Node3D
var sun: DirectionalLight3D

func setup(parent: Node3D, content: Node, maps: Node = null) -> void:
    root = parent
    database = content
    map_db = maps
    world_root = Node3D.new()
    world_root.name = "WorldRoot"
    root.add_child(world_root)

func build_hq() -> void:
    _reset()
    _make_environment(Color("#08111e"), Color("#d8ebff"))
    Factory.box(world_root,Vector3(54,0.5,54),Vector3(0,-0.25,0),Color("#2b3449"))
    for p in [Vector3(-16,0,-12),Vector3(16,0,-12),Vector3(-16,0,12),Vector3(16,0,12)]:
        var holder := Node3D.new()
        holder.position=p
        world_root.add_child(holder)
        Factory.box(holder,Vector3(1.3,2.1,1.3),Vector3(0,1.05,0),Color("#596885"))
        Factory.sphere(holder,0.65,Vector3(0,2.25,0),Color("#70d9dd"))
    portal=Factory.make_portal(world_root,Vector3(0,0,0),Color("#5bdcff"))
    Factory.box(world_root,Vector3(8,0.4,5),Vector3(-11,0.05,-5),Color("#394762"))
    Factory.box(world_root,Vector3(8,0.4,5),Vector3(11,0.05,-5),Color("#394762"))
    Factory.box(world_root,Vector3(3.5,0.24,3.5),Vector3(0,0.12,8),Color("#32425c"))
    _make_hq_details()
    _make_hq_districts()

func build_biome(id: String) -> void:
    _reset()
    var b: Dictionary = map_db.get_map(id) if map_db else database.BIOMES.get(id,database.BIOMES["verdant_frontier"])
    _make_environment(b.get("fog",Color("#8fb1a5")),b.get("accent",Color("#d8ebff")))
    var ground_color:Color=b.get("ground",Color("#4ea66f"))
    var ground_accent:Color=b.get("accent",Color("#d8ebff"))
    var terrain:=Factory.box(world_root,Vector3(58,0.5,58),Vector3(0,-0.25,0),ground_color)
    var terrain_material:=ShaderMaterial.new()
    terrain_material.shader=GroundShader
    terrain_material.set_shader_parameter("base_color",ground_color)
    terrain_material.set_shader_parameter("accent_color",ground_color.lerp(ground_accent,0.28))
    terrain_material.set_shader_parameter("variation_strength",0.20)
    terrain.material_override=terrain_material
    if map_db:
        for obstacle in b.get("obstacles",[]):
            _make_obstacle(obstacle,b.get("accent",Color.WHITE))
    _make_biome_decor(id,b)
    if b.has("resonance_anchor"):
        Factory.make_resonance_anchor(world_root,b["resonance_anchor"],b.get("accent",Color("#69e8cc")))
    elif id=="nimbara":
        Factory.make_resonance_anchor(world_root,Vector3(0,0,-8.5))
    portal=Factory.make_portal(world_root,Vector3(0,0,0),b.get("accent",Color("#5bdcff")))
    _make_hazard_markers(id,b.get("accent",Color.WHITE))

func _make_biome_decor(id:String,b:Dictionary)->void:
    var accent:Color=b.get("accent",Color.WHITE)
    var ground:Color=b.get("ground",Color("#4ea66f"))
    match id:
        "nimbara":
            _make_memory_lake()
            for p in [Vector3(-20,0,-18),Vector3(20,0,-18),Vector3(-21,0,18),Vector3(20,0,19)]:
                _tree(p,accent,Color("#493c3e"),4.8)
            for i in range(7):
                var x:float=-13.0+float(i)*4.3
                Factory.make_crystal(world_root,Vector3(x,0.05,-16.0 if i%2==0 else 16.0),accent.lerp(Color("#c084fc"),float(i%3)*0.22))
            for p in [Vector3(-8,0,13),Vector3(-5,0,14),Vector3(-2,0,13),Vector3(7,0,-15)]:
                _memory_bloom(p,accent)
            for p in b.get("memory_echoes",[]):
                _memory_echo(p)
        "verdant_frontier":
            for p in [Vector3(-18,0,-18),Vector3(18,0,-17),Vector3(-19,0,17),Vector3(17,0,18)]:
                _tree(p,accent,ground)
        "crystal_forest":
            for p in [Vector3(-18,0,0),Vector3(18,0,0),Vector3(-16,0,17),Vector3(17,0,-16)]:
                Factory.make_crystal(world_root,p+Vector3(0,0,0),accent)
        "sunset_desert":
            for p in [Vector3(-18,0,-15),Vector3(18,0,-14),Vector3(-17,0,15),Vector3(18,0,16)]:
                _cactus(p,accent)
        "rust_canyons":
            for p in [Vector3(-18,0,-16),Vector3(17,0,-14),Vector3(-17,0,16),Vector3(16,0,17)]:
                _scrap_stack(p,accent)
        "sky_ruins":
            for p in [Vector3(-18,0,-15),Vector3(17,0,-15),Vector3(-17,0,15),Vector3(18,0,15)]:
                _ruin_pillar(p,accent)
        "nexus_core":
            _make_nexus_bridge(accent)
        "umbral":
            _make_umbral_gallery(accent)
        "ivern":
            _make_ivern_aurora(accent)
        "ferrumia":
            _make_ferrumia_tracks(accent)
        "aurelio":
            _make_aurelio_ruins(accent,ground)
        "vesper":
            _make_vesper_cove(accent,ground)

func _make_nexus_bridge(accent:Color)->void:
    var anchor_colors:Array=[Color("#4bd2e6"),Color("#ff795d"),Color("#9be082"),Color("#f6d278"),Color("#8bc8ff"),Color("#d58df5"),Color("#e8efff"),accent]
    for i in range(8):
        var angle:=TAU*float(i)/8.0
        var position:=Vector3(cos(angle)*20.0,0,sin(angle)*20.0)
        Factory.box(world_root,Vector3(2.6,0.28,2.0),position+Vector3(0,0.14,0),Color("#555b7c"))
        Factory.make_crystal(world_root,position+Vector3(0,0.35,0),anchor_colors[i])
        Factory.torus(world_root,0.45,0.54,position+Vector3(0,0.2,0),anchor_colors[i])
    for p in [Vector3(-22,0,-22),Vector3(22,0,-22),Vector3(-22,0,22),Vector3(22,0,22)]:
        var shard:=Factory.make_crystal(world_root,p+Vector3(0,0.15,0),accent.lightened(0.1))
        shard.scale=Vector3(1.6,1.8,1.6)
    Factory.torus(world_root,4.0,4.2,Vector3(0,0.18,0),accent.darkened(0.1))
    Factory.make_crystal(world_root,Vector3(0,0.15,-4.5),Color("#82f4e4"))
    Factory.torus(world_root,0.62,0.76,Vector3(0,0.15,-4.5),Color("#82f4e4"))

func _make_umbral_gallery(accent:Color)->void:
    # Mirror panels are static blockout props; no reflection or geometry shift is simulated.
    for p in [Vector3(-18,0,-16),Vector3(18,0,-16),Vector3(-18,0,16),Vector3(18,0,16)]:
        var column:=Factory.box(world_root,Vector3(1.2,4.8,1.2),p+Vector3(0,2.4,0),Color("#49445d"))
        column.rotation.y=0.2
        Factory.torus(world_root,0.38,0.45,p+Vector3(0,4.95,0),accent)
    for p in [Vector3(-8,0,0),Vector3(8,0,0),Vector3(0,0,-18)]:
        Factory.box(world_root,Vector3(4.0,3.8,0.35),p+Vector3(0,1.9,0),Color("#867496"))
        Factory.box(world_root,Vector3(3.2,3.1,0.08),p+Vector3(0,1.9,-0.22),Color("#b39bc1"))
    for p in [Vector3(-4,0,12),Vector3(4,0,12)]:
        Factory.make_crystal(world_root,p+Vector3(0,0.1,0),accent.lightened(0.10))

func _make_ivern_aurora(accent:Color)->void:
    # The sky arcs are fixed low-cost landmarks, not dynamic aurora or wind gameplay.
    for p in [Vector3(-19,0,-15),Vector3(19,0,-15),Vector3(-18,0,16),Vector3(18,0,16)]:
        Factory.make_crystal(world_root,p+Vector3(0,0.1,0),accent)
    for i in range(3):
        var arc:=Factory.torus(world_root,8.0+float(i)*1.1,8.25+float(i)*1.1,Vector3(0,4.0+float(i)*0.55,-17),Color("#a8caff").lerp(Color("#d69cff"),float(i)*0.22))
        arc.rotation_degrees=Vector3(20.0,-18.0+float(i)*18.0,0)
        arc.scale=Vector3(1.25,0.6,1.0)
    for p in [Vector3(-18,0,0),Vector3(18,0,0)]:
        Factory.box(world_root,Vector3(1.3,5.2,1.3),p+Vector3(0,2.6,0),Color("#667c9a"))
        Factory.make_crystal(world_root,p+Vector3(0,5.2,0),accent.lightened(0.12))

func _make_ferrumia_tracks(accent:Color)->void:
    # Static rails and tower pieces suggest the industrial district; they do not move.
    for z in [-8.0,0.0,8.0]:
        Factory.box(world_root,Vector3(38,0.16,0.42),Vector3(0,0.08,z),Color("#353341"))
        for x in range(-17,18,4):
            Factory.box(world_root,Vector3(1.3,0.22,1.4),Vector3(float(x),0.18,z),Color("#827264"))
    for p in [Vector3(-18,0,-16),Vector3(18,0,-16),Vector3(-18,0,16),Vector3(18,0,16)]:
        Factory.box(world_root,Vector3(2.8,4.2,2.8),p+Vector3(0,2.1,0),Color("#65566d"))
        Factory.box(world_root,Vector3(3.4,0.22,3.4),p+Vector3(0,4.25,0),accent.darkened(0.18))
        Factory.sphere(world_root,0.35,p+Vector3(0,3.1,0),Color("#64d8f2"))
    _make_ferrumia_gear(Vector3(0,0,12),accent,Vector3(2.3,0.6,2.3))

func _make_ferrumia_gear(pos:Vector3,accent:Color,size:Vector3)->void:
    var gear:=Node3D.new()
    gear.position=pos+Vector3(0,0.22,0)
    world_root.add_child(gear)
    var ring:=Factory.torus(gear,size.x*0.25,size.x*0.42,Vector3.ZERO,Color("#b77961"))
    ring.rotation.x=PI*0.5
    for i in range(8):
        var angle:=TAU*float(i)/8.0
        var tooth:=Factory.box(gear,Vector3(0.34,0.48,0.36),Vector3(cos(angle)*size.x*0.46,0.02,sin(angle)*size.z*0.46),accent)
        tooth.rotation.y=-angle
    Factory.cylinder(gear,0.16,0.22,0.32,Vector3(0,0.05,0),Color("#4b4155"))

func _make_aurelio_ruins(accent:Color,ground:Color)->void:
    # Desert ornaments are blockout landmarks; no temporal puzzle or moving platform is implied.
    for i in range(5):
        var ridge:=Factory.sphere(world_root,1.0,Vector3(-18.0+float(i)*9.0,0.08,18.0 if i%2==0 else -18.0),ground.lightened(0.10))
        ridge.scale=Vector3(5.0,0.18,2.2)
    for p in [Vector3(-19,0,-16),Vector3(19,0,-15),Vector3(-18,0,16),Vector3(18,0,17)]:
        _aurelio_pillar(p,accent,Vector3(2.2,3.2,2.2))
    for p in [Vector3(-3,0,-19),Vector3(0,0,-19),Vector3(3,0,-19)]:
        Factory.box(world_root,Vector3(1.8,0.35,1.4),p+Vector3(0,1.1,0),Color("#8a644d"))
        Factory.make_crystal(world_root,p+Vector3(0,1.45,0),accent.lightened(0.08))
    Factory.sphere(world_root,0.17,Vector3(0,0.16,7),Color("#46aeb2"))
    Factory.torus(world_root,2.0,2.15,Vector3(0,0.18,7),Color("#ffd988"))

func _aurelio_pillar(pos:Vector3,accent:Color,size:Vector3)->void:
    var pillar:=Node3D.new()
    pillar.position=pos
    world_root.add_child(pillar)
    Factory.box(pillar,Vector3(size.x*0.72,size.y*0.78,size.z*0.72),Vector3(0,size.y*0.39,0),Color("#906b55"))
    Factory.box(pillar,Vector3(size.x,0.24,size.z),Vector3(0,size.y*0.82,0),accent.darkened(0.24))
    Factory.box(pillar,Vector3(size.x*0.34,0.16,size.z*0.38),Vector3(0,size.y*0.45,-size.z*0.38),accent)
    Factory.sphere(pillar,0.16,Vector3(0,size.y+0.12,0),accent.lightened(0.16))

func _make_vesper_cove(accent:Color,ground:Color)->void:
    # Water and dock geometry are a navigable-scene blockout, not final art or tide simulation.
    for lake in [
        {"pos":Vector3(-12,0.035,2),"scale":Vector3(7.5,0.045,10.0)},
        {"pos":Vector3(12,0.035,-1),"scale":Vector3(7.0,0.045,9.0)},
        {"pos":Vector3(0,0.035,21),"scale":Vector3(12.0,0.045,4.5)}
    ]:
        var water:=Factory.sphere(world_root,1.0,lake.pos,Color("#287b91"))
        water.scale=lake.scale
        Factory.torus(world_root,0.95,1.02,lake.pos+Vector3(0,0.025,0),accent.darkened(0.16)).scale=lake.scale*Vector3(1.04,1.0,1.04)
    for p in [Vector3(-18,0,11),Vector3(18,0,10),Vector3(-17,0,-15),Vector3(17,0,-16)]:
        _vesper_coral(p,accent,ground)
    for p in [Vector3(-3,0,-18),Vector3(4,0,-20),Vector3(8,0,-18)]:
        Factory.make_crystal(world_root,p+Vector3(0,0.1,0),accent.lightened(0.18))

func _vesper_coral(pos:Vector3,accent:Color,ground:Color)->void:
    var coral:=Node3D.new()
    coral.position=pos
    world_root.add_child(coral)
    Factory.sphere(coral,0.52,Vector3(0,0.48,0),Color("#dc796f"))
    for i in range(5):
        var side:float=-1.0 if i%2==0 else 1.0
        var branch:=Factory.cylinder(coral,0.09,0.15,0.9+float(i%3)*0.22,Vector3(side*float(i%3)*0.22,1.0+float(i%3)*0.16,0),accent.lightened(float(i%2)*0.12))
        branch.rotation.z=side*(0.18+float(i%3)*0.12)
    Factory.box(coral,Vector3(1.15,0.12,1.0),Vector3(0,0.05,0),ground.darkened(0.12))

func _make_memory_lake()->void:
    var surface:=Factory.sphere(world_root,1.0,Vector3(0,0.06,13),Color("#347f97"))
    surface.scale=Vector3(5.3,0.045,3.6)
    Factory.torus(world_root,2.9,3.02,Vector3(0,0.09,13),Color("#57d6c7"))
    Factory.torus(world_root,1.55,1.62,Vector3(0,0.10,13),Color("#75e5d5"))

func _memory_echo(pos:Vector3)->void:
    var marker:=Node3D.new()
    marker.position=pos
    world_root.add_child(marker)
    Factory.make_crystal(marker,Vector3(0,0.9,0),Color("#c6fff8"))
    Factory.torus(marker,0.25,0.36,Vector3(0,0.18,0),Color("#68f5e6"))
    Factory.sphere(marker,0.12,Vector3(0,1.8,0),Color("#f0fffd"))

func _make_obstacle(obstacle:Dictionary,accent:Color)->void:
    var kind:=str(obstacle.get("shape","rock"))
    var pos:Vector3=obstacle.get("pos",Vector3.ZERO)
    var size:Vector3=obstacle.get("size",Vector3.ONE)
    match kind:
        "tree":
            _tree(pos,accent,Color("#5a4939"),maxf(2.7,size.y))
        "crystal":
            Factory.box(world_root,Vector3(size.x,0.10,size.z),pos+Vector3(0,0.05,0),Color("#465f86"))
            Factory.make_crystal(world_root,pos+Vector3(0,size.y*0.45,0),accent)
        "cactus":
            _cactus(pos,accent,maxf(1.0,size.y/1.9))
        "scrap":
            _scrap_stack(pos,accent,size)
        "anchor":
            Factory.box(world_root,Vector3(size.x*0.45,size.y,size.z*0.45),pos+Vector3(0,size.y*0.5,0),Color("#555a7b"))
            Factory.make_crystal(world_root,pos+Vector3(0,size.y*0.82,0),Color("#c5a2ff"))
            Factory.torus(world_root,size.x*0.35,size.x*0.43,pos+Vector3(0,size.y*0.62,0),accent)
        "mirror":
            var panel:=Factory.box(world_root,Vector3(size.x,size.y,size.z),pos+Vector3(0,size.y*0.5,0),Color("#817392"))
            Factory.box(world_root,Vector3(size.x*0.78,size.y*0.82,0.08),pos+Vector3(0,size.y*0.5,-0.25),Color("#b39bc1"))
            Factory.torus(world_root,0.42,0.50,pos+Vector3(0,size.y*0.50,-0.18),accent)
        "snowbank":
            var bank:=Factory.sphere(world_root,1.0,pos+Vector3(0,size.y*0.42,0),Color("#c9d8ec"))
            bank.scale=Vector3(size.x*0.5,size.y*0.55,size.z*0.5)
        "ice":
            var ice:=Factory.box(world_root,Vector3(size.x,size.y,size.z),pos+Vector3(0,size.y*0.5,0),Color("#91c9e2"))
            ice.rotation.y=0.14
        "gear":
            _make_ferrumia_gear(pos,accent,size)
        "sandstone":
            _aurelio_pillar(pos,accent,size)
        "pier":
            var dock:=Node3D.new()
            dock.position=pos
            world_root.add_child(dock)
            for i in range(4):
                Factory.box(dock,Vector3(size.x*0.24,size.y,size.z),Vector3((float(i)-1.5)*size.x*0.24,size.y*0.5,0),Color("#795c55"))
            for x in [-0.42,0.42]:
                Factory.cylinder(dock,0.10,0.13,1.35,Vector3(size.x*x,0.68,-size.z*0.35),accent.darkened(0.2))
        "coral":
            _vesper_coral(pos,accent,Color("#376e77"))
        "ruin":
            _ruin_pillar(pos,accent,size)
        "root":
            var root_mesh:=Factory.cylinder(world_root,0.18,0.32,size.x,pos+Vector3(0,size.y*0.35,0),Color("#765348"))
            root_mesh.rotation.z=0.12
            Factory.sphere(world_root,0.36,pos+Vector3(-size.x*0.32,size.y*0.7,0),accent.darkened(0.22))
        _:
            Factory.box(world_root,Vector3(size.x,0.35,size.z),pos+Vector3(0,0.17,0),Color("#4b5567"))
            var rock:=Factory.sphere(world_root,maxf(0.45,minf(size.x,size.z)*0.42),pos+Vector3(0,size.y*0.45,0),accent.darkened(0.45))
            rock.scale=Vector3(1.0,size.y/maxf(0.8,minf(size.x,size.z)),1.0)

func _tree(pos:Vector3,accent:Color,ground:Color,height:float=2.8)->void:
    var root_node:=Node3D.new()
    root_node.position=pos
    world_root.add_child(root_node)
    Factory.cylinder(root_node,0.24,0.34,height*0.52,Vector3(0,height*0.26,0),Color("#5f4539"))
    var crown:=Factory.sphere(root_node,height*0.30,Vector3(0,height*0.72,0),accent)
    crown.scale=Vector3(1.15,1.0,1.0)
    Factory.sphere(root_node,height*0.18,Vector3(-height*0.25,height*0.68,0.15),accent.lightened(0.08))
    Factory.sphere(root_node,height*0.18,Vector3(height*0.22,height*0.67,-0.12),accent.darkened(0.05))
    Factory.box(root_node,Vector3(0.38,0.16,0.38),Vector3(0,0.05,0),ground)

func _memory_bloom(pos:Vector3,accent:Color)->void:
    var flower:=Node3D.new()
    flower.position=pos
    world_root.add_child(flower)
    Factory.cylinder(flower,0.035,0.05,0.42,Vector3(0,0.21,0),Color("#91d78d"))
    for i in range(5):
        var angle:=float(i)*TAU/5.0
        var petal:=Factory.sphere(flower,0.12,Vector3(cos(angle)*0.12,0.43,sin(angle)*0.12),accent.lightened(0.14))
        petal.scale=Vector3(0.72,1.0,0.72)
    Factory.sphere(flower,0.08,Vector3(0,0.44,0),Color("#ffe88a"))

func _cactus(pos:Vector3,accent:Color,scale_factor:float=1.0)->void:
    var root_node:=Node3D.new()
    root_node.position=pos
    world_root.add_child(root_node)
    Factory.cylinder(root_node,0.20,0.28,1.7*scale_factor,Vector3(0,0.85*scale_factor,0),Color("#6a995b"))
    Factory.cylinder(root_node,0.11,0.15,0.62*scale_factor,Vector3(-0.42*scale_factor,0.72*scale_factor,0),Color("#6a995b")).rotation.z=-0.8
    Factory.cylinder(root_node,0.11,0.15,0.62*scale_factor,Vector3(0.42*scale_factor,0.48*scale_factor,0),Color("#6a995b")).rotation.z=0.8
    Factory.sphere(root_node,0.14*scale_factor,Vector3(0,1.72*scale_factor,0),accent)

func _scrap_stack(pos:Vector3,accent:Color,size:Vector3=Vector3(2.0,2.0,2.0))->void:
    var root_node:=Node3D.new()
    root_node.position=pos
    world_root.add_child(root_node)
    Factory.box(root_node,Vector3(size.x*0.82,size.y*0.52,size.z*0.72),Vector3(0,size.y*0.26,0),Color("#4f5966"))
    Factory.box(root_node,Vector3(size.x*0.46,size.y*0.34,size.z*0.44),Vector3(-size.x*0.20,size.y*0.68,0),accent.darkened(0.18))
    Factory.box(root_node,Vector3(size.x*0.34,size.y*0.24,size.z*0.55),Vector3(size.x*0.21,size.y*0.62,-size.z*0.10),accent)
    Factory.sphere(root_node,0.14,Vector3(0,size.y*0.92,0),accent)

func _ruin_pillar(pos:Vector3,accent:Color,size:Vector3=Vector3(2.0,3.0,2.0))->void:
    var root_node:=Node3D.new()
    root_node.position=pos
    world_root.add_child(root_node)
    Factory.box(root_node,Vector3(size.x*0.68,size.y,size.z*0.68),Vector3(0,size.y*0.5,0),Color("#5d6782"))
    Factory.box(root_node,Vector3(size.x*0.86,0.20,size.z*0.86),Vector3(0,size.y+0.10,0),accent)
    Factory.box(root_node,Vector3(size.x*0.36,0.20,size.z*0.40),Vector3(0,size.y*0.5,-size.z*0.40),accent.lightened(0.12))

func _make_hazard_markers(id:String,accent:Color)->void:
    var marker_color:=accent.darkened(0.20)
    for p in [Vector3(-4,0.025,-4),Vector3(4,0.025,-4),Vector3(-4,0.025,4),Vector3(4,0.025,4)]:
        var ring:=Factory.torus(world_root,0.42,0.06,p,marker_color)
        ring.rotation.x=PI*0.5
    var label:=Label3D.new()
    label.text=str(map_db.hazard(id)) if map_db else ""
    label.position=Vector3(0,0.15,2.9)
    label.modulate=accent
    label.font_size=18
    label.outline_size=4
    world_root.add_child(label)

func _make_hq_details()->void:
    for p in [Vector3(-22,0,-20),Vector3(22,0,-20),Vector3(-22,0,20),Vector3(22,0,20)]:
        var root_node:=Node3D.new()
        root_node.position=p
        world_root.add_child(root_node)
        Factory.cylinder(root_node,0.12,0.16,1.3,Vector3(0,0.65,0),Color("#3f4b61"))
        Factory.make_crystal(root_node,Vector3(0,1.4,0),Color("#7defff"))

func _make_hq_districts()->void:
    # Static district landmarks give the small blockout base readable destinations.
    Factory.torus(world_root,4.8,5.05,Vector3(0,0.035,0),Color("#4fb8d8"))
    for i in range(8):
        var angle:=TAU*float(i)/8.0
        var point:=Vector3(cos(angle)*5.35,0.12,sin(angle)*5.35)
        Factory.make_crystal(world_root,point,Color("#63dfe8").lerp(Color("#c4a3ff"),float(i%2)*0.65))

    # Workshop of the Resonances: a copper workbench and a fixed gear landmark.
    Factory.box(world_root,Vector3(4.8,0.22,2.2),Vector3(-11,0.31,-5),Color("#716276"))
    Factory.box(world_root,Vector3(2.6,0.72,1.1),Vector3(-11,0.82,-5.25),Color("#374354"))
    Factory.make_crystal(world_root,Vector3(-11,1.38,-5.25),Color("#7defff"))
    _make_ferrumia_gear(Vector3(-13.5,0.1,-6.7),Color("#dfa66d"),Vector3(1.2,0.6,1.2))

    # Floating market: four thin posts, a bright canopy and three stall counters.
    for x in [-13.0,-9.0]:
        for z in [-7.0,-3.0]:
            Factory.cylinder(world_root,0.07,0.09,2.0,Vector3(x,1.1,z),Color("#8c789b"))
    Factory.box(world_root,Vector3(4.4,0.18,4.4),Vector3(11,2.12,-5),Color("#5e7194"))
    Factory.box(world_root,Vector3(1.5,0.65,0.8),Vector3(9.6,0.55,-5.7),Color("#b78667"))
    Factory.box(world_root,Vector3(1.5,0.65,0.8),Vector3(11.0,0.55,-5.7),Color("#658b91"))
    Factory.box(world_root,Vector3(1.5,0.65,0.8),Vector3(12.4,0.55,-5.7),Color("#a77b9d"))
    for point in [Vector3(9,0.3,-4),Vector3(13,0.3,-4)]:
        Factory.make_crystal(world_root,point,Color("#ffc78a"))

    # Library of the Guardians: stepped shelves and a pair of arch pillars.
    Factory.box(world_root,Vector3(5.8,0.3,4.0),Vector3(-11,0.22,-14),Color("#394b67"))
    for side in [-1.0,1.0]:
        Factory.box(world_root,Vector3(0.38,3.8,0.42),Vector3(-11+side*2.5,2.0,-14),Color("#58668b"))
    for shelf in range(3):
        var z:= -15.2+float(shelf)*1.1
        Factory.box(world_root,Vector3(3.7,0.16,0.22),Vector3(-11,0.7+float(shelf)*0.9,z),Color("#8e7d87"))
        for book in range(6):
            var color:=Color("#67b4c5") if (book+shelf)%2==0 else Color("#c18f6d")
            Factory.box(world_root,Vector3(0.38,0.52,0.25),Vector3(-12.45+float(book)*0.58,1.02+float(shelf)*0.9,z),color)

    # Training garden: moving is still a gameplay task; these targets remain static.
    Factory.torus(world_root,2.6,2.78,Vector3(11,0.08,11),Color("#a2de8b"))
    for index in range(3):
        var x:=9.0+float(index)*2.0
        Factory.box(world_root,Vector3(0.52,1.65,0.46),Vector3(x,0.88,11),Color("#576b61"))
        Factory.sphere(world_root,0.38,Vector3(x,1.9,11),Color("#d5bf91"))
        Factory.sphere(world_root,0.12,Vector3(x,1.95,10.6),Color("#55dcef"))

func _reset()->void:
    if world_root and is_instance_valid(world_root):
        world_root.free()
    world_root=Node3D.new()
    world_root.name="WorldRoot"
    root.add_child(world_root)
    if sun and is_instance_valid(sun):
        sun.free()
    var old_env:=root.get_node_or_null("World_Environment")
    if old_env:old_env.free()

func _make_environment(background:Color,ambient:Color)->void:
    var node:=WorldEnvironment.new()
    node.name="World_Environment"
    var env:=Environment.new()
    env.background_mode=Environment.BG_COLOR
    env.background_color=background
    env.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color=ambient
    env.ambient_light_energy=0.88
    env.tonemap_mode=Environment.TONE_MAPPER_FILMIC
    env.fog_enabled=true
    env.fog_light_color=background.lightened(0.10)
    env.fog_light_energy=0.55
    env.fog_density=0.008
    node.environment=env
    root.add_child(node)
    sun=DirectionalLight3D.new()
    sun.name="Sun"
    sun.rotation_degrees=Vector3(-54,-30,0)
    sun.light_energy=1.2
    sun.shadow_enabled=true
    root.add_child(sun)
