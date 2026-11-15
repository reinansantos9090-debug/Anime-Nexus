extends Node
## Twelve offline expedition maps. Each biome owns its encounter pool,
## difficulty, obstacle layout and environmental hazard.

var maps: Dictionary = {}

func _ready() -> void:
    maps = {
        "nimbara": {
            "name":"Nimbara • Floresta das Memórias",
            "difficulty":1.0,
            "duration":180.0,
            "goal":4,
            "hazard":"raízes da memória",
            "interaction_points":{"prologue_resonator":Vector3(0,0,-8.5),"akari_flame_bloom":Vector3(-15,0,0),"ren_wind_chime":Vector3(16,0,-2),"mira_memory_prism":Vector3(-18,0,-1),"yuna_lunar_seal":Vector3(18,0,-5),"shin_shadow_reflection":Vector3(0,0,-20)},
            "ground":Color("#376a59"),
            "accent":Color("#63ead0"),
            "fog":Color("#557f7c"),
            "enemies":["moss_hopper","leaf_spark","crystal_stagling","root_guardian"],
            "memory_echoes":[Vector3(-6,0,10),Vector3(6,0,10),Vector3(0,0,17)],
            "obstacles":[
                {"shape":"tree","pos":Vector3(-10,0,-9),"size":Vector3(1.6,4.5,1.6)},
                {"shape":"tree","pos":Vector3(10,0,-10),"size":Vector3(1.5,4.1,1.5)},
                {"shape":"crystal","pos":Vector3(-12,0,5),"size":Vector3(1.1,2.5,1.1)},
                {"shape":"root","pos":Vector3(-5,0,-2),"size":Vector3(3.8,0.8,1.0)},
                {"shape":"rock","pos":Vector3(8,0,6),"size":Vector3(2.2,1.3,1.8)},
                {"shape":"tree","pos":Vector3(13,0,12),"size":Vector3(1.4,4.0,1.4)},
                {"shape":"crystal","pos":Vector3(3,0,-13),"size":Vector3(1.0,2.2,1.0)}
            ]
        },
        "verdant_frontier": {
            "name":"Fronteira Esmeralda",
            "difficulty":1.00,
            "duration":150.0,
            "goal":10,
            "hazard":"raízes móveis",
            "ground":Color("#4ea66f"),
            "accent":Color("#8bd8ff"),
            "fog":Color("#9fe4c3"),
            "enemies":["aether_slime","neon_stalker","thornling","briar_charger","moss_mender","gale_moth"],
            "obstacles":[
                {"shape":"rock","pos":Vector3(-9,0,-7),"size":Vector3(2.0,1.4,1.7)},
                {"shape":"rock","pos":Vector3(9,0,-8),"size":Vector3(2.4,1.8,2.0)},
                {"shape":"tree","pos":Vector3(-13,0,5),"size":Vector3(1.2,2.7,1.2)},
                {"shape":"tree","pos":Vector3(12,0,6),"size":Vector3(1.0,3.0,1.0)},
                {"shape":"rock","pos":Vector3(-3,0,10),"size":Vector3(2.8,1.2,1.6)},
                {"shape":"tree","pos":Vector3(4,0,-12),"size":Vector3(1.1,2.4,1.1)}
            ]
        },
        "crystal_forest": {
            "name":"Floresta Cristalina",
            "difficulty":1.25,
            "duration":165.0,
            "goal":12,
            "hazard":"pulsos cristalinos",
            "ground":Color("#547fc4"),
            "accent":Color("#a3fff4"),
            "fog":Color("#89aef0"),
            "enemies":["crystal_sentinel","rift_hound","phase_moth","prism_oracle","frost_spitter","echo_blinker"],
            "obstacles":[
                {"shape":"crystal","pos":Vector3(-10,0,-9),"size":Vector3(1.4,2.8,1.4)},
                {"shape":"crystal","pos":Vector3(10,0,-7),"size":Vector3(1.2,2.4,1.2)},
                {"shape":"crystal","pos":Vector3(-6,0,8),"size":Vector3(1.6,3.1,1.6)},
                {"shape":"rock","pos":Vector3(8,0,10),"size":Vector3(2.2,1.5,1.8)},
                {"shape":"crystal","pos":Vector3(1,0,-13),"size":Vector3(1.1,2.2,1.1)},
                {"shape":"rock","pos":Vector3(13,0,1),"size":Vector3(2.0,1.7,2.0)}
            ]
        },
        "sunset_desert": {
            "name":"Deserto do Poente",
            "difficulty":1.45,
            "duration":175.0,
            "goal":14,
            "hazard":"ondas de calor",
            "ground":Color("#d39a57"),
            "accent":Color("#ffcf7d"),
            "fog":Color("#f0bd8a"),
            "enemies":["dune_bomber","solar_scarab","sand_sniper","mirage_runner","ember_beetle","burrower"],
            "obstacles":[
                {"shape":"rock","pos":Vector3(-12,0,-8),"size":Vector3(3.0,1.8,2.3)},
                {"shape":"rock","pos":Vector3(11,0,-10),"size":Vector3(2.5,1.5,2.5)},
                {"shape":"cactus","pos":Vector3(-9,0,7),"size":Vector3(0.8,2.2,0.8)},
                {"shape":"cactus","pos":Vector3(8,0,5),"size":Vector3(1.0,2.4,1.0)},
                {"shape":"rock","pos":Vector3(0,0,11),"size":Vector3(3.2,1.4,1.8)},
                {"shape":"cactus","pos":Vector3(4,0,-13),"size":Vector3(0.8,2.0,0.8)}
            ]
        },
        "rust_canyons": {
            "name":"Cânions de Sucata",
            "difficulty":1.70,
            "duration":185.0,
            "goal":16,
            "hazard":"campos magnéticos",
            "ground":Color("#8a5d50"),
            "accent":Color("#ffc36a"),
            "fog":Color("#9d7970"),
            "enemies":["scrap_golem","magnet_turret","coil_guardian","scrap_swarm","crusher","repair_drone"],
            "obstacles":[
                {"shape":"scrap","pos":Vector3(-11,0,-9),"size":Vector3(2.4,2.4,2.0)},
                {"shape":"scrap","pos":Vector3(9,0,-8),"size":Vector3(3.0,1.9,2.4)},
                {"shape":"scrap","pos":Vector3(-8,0,8),"size":Vector3(2.0,3.0,2.0)},
                {"shape":"scrap","pos":Vector3(11,0,7),"size":Vector3(2.8,2.2,2.2)},
                {"shape":"rock","pos":Vector3(0,0,-11),"size":Vector3(3.5,1.6,2.0)},
                {"shape":"scrap","pos":Vector3(1,0,11),"size":Vector3(2.5,2.0,2.6)}
            ]
        },
        "sky_ruins": {
            "name":"Ruínas do Céu",
            "difficulty":2.00,
            "duration":195.0,
            "goal":18,
            "hazard":"rajadas gravitacionais",
            "ground":Color("#6178b1"),
            "accent":Color("#e0f7ff"),
            "fog":Color("#b4c9ff"),
            "enemies":["sky_watcher","rift_assassin","gravity_wisp","void_glider","storm_caster","chrono_knight"],
            "obstacles":[
                {"shape":"ruin","pos":Vector3(-12,0,-9),"size":Vector3(2.2,3.4,2.2)},
                {"shape":"ruin","pos":Vector3(12,0,-9),"size":Vector3(2.5,4.0,2.5)},
                {"shape":"ruin","pos":Vector3(-9,0,8),"size":Vector3(2.8,3.1,2.0)},
                {"shape":"ruin","pos":Vector3(10,0,9),"size":Vector3(2.2,3.7,2.2)},
                {"shape":"ruin","pos":Vector3(0,0,-12),"size":Vector3(2.0,2.8,2.4)},
                {"shape":"ruin","pos":Vector3(0,0,11),"size":Vector3(3.0,2.4,2.0)}
            ]
        },
        "nexus_core": {
            "name":"Núcleo do Nexo • Ponte dos Fragmentos",
            "difficulty":1.85,"duration":200.0,"goal":18,"hazard":"ondas de estase","resonance_anchor":Vector3(0,0,-8.5),"interaction_points":{"observatory_return":Vector3(0,0,-4.5)},
            "ground":Color("#343d63"),"accent":Color("#c4a3ff"),"fog":Color("#69739f"),
            "enemies":["memory_warden","tide_echo","gear_echo","frost_echo","root_echo","hour_echo"],
            "obstacles":[
                {"shape":"anchor","pos":Vector3(-15,0,-12),"size":Vector3(2.0,3.2,2.0)},
                {"shape":"anchor","pos":Vector3(15,0,-12),"size":Vector3(2.0,3.2,2.0)},
                {"shape":"anchor","pos":Vector3(-17,0,10),"size":Vector3(2.0,3.2,2.0)},
                {"shape":"anchor","pos":Vector3(17,0,10),"size":Vector3(2.0,3.2,2.0)},
                {"shape":"ruin","pos":Vector3(-9,0,-19),"size":Vector3(2.0,2.6,2.0)},
                {"shape":"ruin","pos":Vector3(9,0,-19),"size":Vector3(2.0,2.6,2.0)},
                {"shape":"crystal","pos":Vector3(-3,0,18),"size":Vector3(1.1,2.8,1.1)},
                {"shape":"crystal","pos":Vector3(3,0,18),"size":Vector3(1.1,2.8,1.1)}
            ]
        },
        "umbral": {
            "name":"Umbral • Jardins do Eclipse",
            "difficulty":1.42,"duration":190.0,"goal":16,"hazard":"ecos de reflexo","resonance_anchor":Vector3(0,0,-8.5),
            "ground":Color("#39334f"),"accent":Color("#d995f0"),"fog":Color("#665a86"),
            "enemies":["shapeless_echo","eclipse_butterfly","mirror_guardian","fractured_shadow","wandering_illusion","silence_watch"],
            "obstacles":[
                {"shape":"mirror","pos":Vector3(-12,0,-9),"size":Vector3(2.6,3.6,0.45)},
                {"shape":"mirror","pos":Vector3(12,0,-9),"size":Vector3(2.6,3.6,0.45)},
                {"shape":"crystal","pos":Vector3(-10,0,9),"size":Vector3(1.4,3.1,1.4)},
                {"shape":"mirror","pos":Vector3(10,0,9),"size":Vector3(2.8,3.0,0.45)},
                {"shape":"ruin","pos":Vector3(0,0,-15),"size":Vector3(3.0,3.3,2.1)},
                {"shape":"mirror","pos":Vector3(-2,0,1),"size":Vector3(2.5,2.8,0.42)},
                {"shape":"crystal","pos":Vector3(0,0,14),"size":Vector3(1.2,2.5,1.2)}
            ]
        },
        "ivern": {
            "name":"Ivern • Montanhas da Aurora",
            "difficulty":1.34,"duration":185.0,"goal":15,"hazard":"rajadas da aurora","resonance_anchor":Vector3(0,0,-8.5),
            "ground":Color("#7183a0"),"accent":Color("#d5e9ff"),"fog":Color("#bdc9e2"),
            "enemies":["snowflake_wisp","boreal_fox","erratic_crystal","blizzard_spirit","frost_guardian","aurora_sentinel"],
            "obstacles":[
                {"shape":"ice","pos":Vector3(-12,0,-10),"size":Vector3(2.8,0.6,2.6)},
                {"shape":"crystal","pos":Vector3(11,0,-10),"size":Vector3(1.3,3.0,1.3)},
                {"shape":"snowbank","pos":Vector3(-10,0,8),"size":Vector3(3.6,1.7,2.8)},
                {"shape":"snowbank","pos":Vector3(11,0,8),"size":Vector3(3.2,1.5,3.0)},
                {"shape":"ice","pos":Vector3(0,0,-15),"size":Vector3(4.2,0.7,2.0)},
                {"shape":"crystal","pos":Vector3(-2,0,2),"size":Vector3(1.0,2.5,1.0)},
                {"shape":"snowbank","pos":Vector3(0,0,14),"size":Vector3(4.5,1.4,2.8)}
            ]
        },
        "ferrumia": {
            "name":"Ferrúmia • Cidade das Engrenagens",
            "difficulty":1.28,
            "duration":180.0,
            "goal":14,
            "hazard":"pulsos magnéticos de trilho",
            "resonance_anchor":Vector3(0,0,-8.5),
            "ground":Color("#594c6d"),
            "accent":Color("#ff8bc7"),
            "fog":Color("#927b9f"),
            "enemies":["prism_drone","living_gear","copper_sentinel","unstable_automaton","magnetic_guardian","mechanical_core"],
            "obstacles":[
                {"shape":"scrap","pos":Vector3(-13,0,-9),"size":Vector3(2.6,2.2,2.1)},
                {"shape":"gear","pos":Vector3(10,0,-10),"size":Vector3(2.6,0.6,2.6)},
                {"shape":"gear","pos":Vector3(-10,0,8),"size":Vector3(2.0,0.55,2.0)},
                {"shape":"scrap","pos":Vector3(13,0,8),"size":Vector3(2.8,2.4,2.2)},
                {"shape":"ruin","pos":Vector3(0,0,-15),"size":Vector3(2.4,4.0,2.4)},
                {"shape":"gear","pos":Vector3(0,0,13),"size":Vector3(2.4,0.65,2.4)},
                {"shape":"scrap","pos":Vector3(-2,0,-2),"size":Vector3(2.4,1.8,2.0)}
            ]
        },
        "aurelio": {
            "name":"Aurélio • Deserto das Horas",
            "difficulty":1.18,
            "duration":175.0,
            "goal":12,
            "hazard":"ecos de areia temporal",
            "resonance_anchor":Vector3(0,0,-8.5),
            "ground":Color("#b78555"),
            "accent":Color("#ffd17e"),
            "fog":Color("#d2a487"),
            "enemies":["aurelio_crystal","sun_disk_scarab","mirage_duplicator","dune_watch","hourglass_wisp","oasis_guardian"],
            "obstacles":[
                {"shape":"sandstone","pos":Vector3(-12,0,-9),"size":Vector3(3.0,3.4,2.7)},
                {"shape":"sandstone","pos":Vector3(12,0,-9),"size":Vector3(2.7,4.0,2.4)},
                {"shape":"ruin","pos":Vector3(-9,0,9),"size":Vector3(2.4,3.0,2.2)},
                {"shape":"ruin","pos":Vector3(9,0,10),"size":Vector3(2.2,3.6,2.2)},
                {"shape":"crystal","pos":Vector3(-2,0,-15),"size":Vector3(1.1,2.7,1.1)},
                {"shape":"cactus","pos":Vector3(14,0,2),"size":Vector3(0.9,2.2,0.9)},
                {"shape":"sandstone","pos":Vector3(0,0,13),"size":Vector3(4.0,1.7,2.4)}
            ]
        },
        "vesper": {
            "name":"Vesper • Arquipélago das Marés",
            "difficulty":1.12,
            "duration":170.0,
            "goal":12,
            "hazard":"correntes de maré",
            "resonance_anchor":Vector3(0,0,-8.5),
            "ground":Color("#376e77"),
            "accent":Color("#59d8d2"),
            "fog":Color("#527f91"),
            "enemies":["bubble_jumper","wandering_coral","astral_jelly","pearl_crab","tide_spirit","abyssal_sentinel"],
            "obstacles":[
                {"shape":"coral","pos":Vector3(-12,0,-9),"size":Vector3(2.2,2.0,2.0)},
                {"shape":"coral","pos":Vector3(11,0,-10),"size":Vector3(2.5,2.3,2.2)},
                {"shape":"pier","pos":Vector3(-8,0,11),"size":Vector3(5.0,0.55,1.5)},
                {"shape":"pier","pos":Vector3(8,0,12),"size":Vector3(4.0,0.55,1.5)},
                {"shape":"rock","pos":Vector3(-14,0,5),"size":Vector3(2.4,1.4,2.0)},
                {"shape":"coral","pos":Vector3(14,0,5),"size":Vector3(2.0,1.8,2.0)},
                {"shape":"rock","pos":Vector3(0,0,-14),"size":Vector3(3.0,1.6,2.1)}
            ]
        }
    }

func get_map(id: String) -> Dictionary:
    return maps.get(id, maps["verdant_frontier"])

func enemy_pool(id: String) -> Array:
    return get_map(id).get("enemies", [])

func difficulty(id: String) -> float:
    return float(get_map(id).get("difficulty", 1.0))

func activity_goal(id: String) -> int:
    return int(get_map(id).get("goal", 10))

func duration(id: String) -> float:
    return float(get_map(id).get("duration", 150.0))

func hazard(id: String) -> String:
    return str(get_map(id).get("hazard", ""))

func blocked(id: String, point: Vector3, radius: float = 0.65) -> bool:
    for obstacle in get_map(id).get("obstacles", []):
        var size: Vector3 = obstacle["size"]
        var pos: Vector3 = obstacle["pos"]
        if absf(point.x - pos.x) <= size.x * 0.5 + radius and absf(point.z - pos.z) <= size.z * 0.5 + radius:
            return true
    return false
