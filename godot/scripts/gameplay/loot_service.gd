extends Node
## The C++ core decides local drop rarity, quantity and value; this node supplies
## deterministic local rolls and applies the result to the offline inventory.

var state:Node
var content:Node
var native_core:AnimeNexusCombatCore
var rng:=RandomNumberGenerator.new()

func setup(game_state:Node,content_db:Node)->void:
    state=game_state
    content=content_db
    native_core=AnimeNexusCombatCore.new()
    rng.seed=73191

func roll(monster_id:String,map_id:String,level:int,event_multiplier:float=1.0)->Dictionary:
    var monster:Dictionary=content.MONSTERS.get(monster_id,{})
    var table:Array=monster.get("loot",[])
    return native_core.resolve_loot(table,int(monster.get("tier",1)),monster_id,map_id,level,event_multiplier,
        rng.randf(),rng.randf(),rng.randi(),rng.randi())

func describe(drop:Dictionary)->String:
    var parts:Array[String]=[]
    for id in drop.get("items",{}).keys():
        parts.append("%s x%d"%[str(id),int(drop["items"][id])])
    return "%s • %s • %d ouro"%[str(drop.get("rarity_name","Comum")),", ".join(parts),int(drop.get("gold",0))]
