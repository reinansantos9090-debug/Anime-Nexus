extends CanvasLayer
## Offline operations terminal. All actions are local and signal-driven.

signal selected(action_id: String)
signal closed

var panel: Panel
var root: Control
var action_buttons:Dictionary={}

const ACTIONS := [
    ["expedition","EXPEDIÇÃO • CONTINUAR","Seguir a missão ativa ou escolher uma região livre"],
    ["craft","OFICINA • MEKA","Ver receitas e criar itens com materiais locais"],
    ["rift","RIFT • CHEFE REGIONAL","Enfrentar o chefe ligado à região atual"],
    ["history","DIÁLOGOS","Continuar o prólogo de Kaien"],
    ["companions","COMPANHEIROS","Escolher até dois aliados offline"],
    ["companion_order","ORDEM • AUTO","Alternar entre combate, seguir e recuar"],
    ["side_quest","MISSÃO • SEMENTES PARA LIORA","Recolher pólen real deixado pelas criaturas"],
    ["memory_quest","MISSÃO • ECOS NO LAGO","Encontrar três ecos de memória escondidos"],
    ["kaien_story","HISTÓRIA DE KAIEN • O BRASÃO","Investigar uma pista antiga da família Arashi"],
    ["saves","SALVAMENTOS","Gerenciar três espaços locais"],
    ["difficulty","DIFICULDADE • AVENTURA","Alternar o desafio da campanha offline"]
]

func _ready() -> void:
    layer = 20
    _build()
    hide_menu()

func _build() -> void:
    root = Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(root)

    var shade := ColorRect.new()
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    shade.color = Color(0.01,0.02,0.05,0.78)
    root.add_child(shade)

    panel = Panel.new()
    panel.size = Vector2(780, 660)
    panel.position = Vector2(250, 30)
    root.add_child(panel)

    var title := Label.new()
    title.text = "CENTRAL DE OPERAÇÕES • OFFLINE"
    title.position = Vector2(32,24)
    title.add_theme_font_size_override("font_size",26)
    panel.add_child(title)

    var subtitle := Label.new()
    subtitle.text = "Escolha uma atividade. Nenhuma conexão de rede é necessária."
    subtitle.position = Vector2(34,62)
    subtitle.add_theme_font_size_override("font_size",15)
    panel.add_child(subtitle)

    for i in range(ACTIONS.size()):
        var data = ACTIONS[i]
        var b := Button.new()
        b.text = str(data[1]) + "\n" + str(data[2])
        b.position = Vector2(32 + (i % 2) * 360, 108 + (i / 2) * 86)
        b.size = Vector2(338, 70)
        b.add_theme_font_size_override("font_size",16)
        var normal := StyleBoxFlat.new()
        normal.bg_color = Color("#162235ee")
        normal.border_color = Color("#5bcfff88")
        normal.set_border_width_all(1)
        normal.set_corner_radius_all(12)
        var hover := normal.duplicate()
        hover.bg_color = Color("#24405fee")
        b.add_theme_stylebox_override("normal", normal)
        b.add_theme_stylebox_override("hover", hover)
        b.add_theme_stylebox_override("pressed", hover)
        action_buttons[str(data[0])]=b
        b.pressed.connect(_choose.bind(str(data[0])))
        panel.add_child(b)

    var close := Button.new()
    close.text = "FECHAR"
    close.position = Vector2(550, 612)
    close.size = Vector2(195, 38)
    close.pressed.connect(hide_menu)
    panel.add_child(close)

func set_difficulty(difficulty_id:String)->void:
    if not action_buttons.has("difficulty"):return
    var labels:Dictionary={"casual":"CASUAL","adventure":"AVENTURA","challenge":"DESAFIO"}
    var label:=str(labels.get(difficulty_id,"AVENTURA"))
    action_buttons["difficulty"].text="DIFICULDADE • "+label+"\nToque para alternar a campanha offline"

func set_companion_order(order_id:String)->void:
    if not action_buttons.has("companion_order"):return
    var labels:Dictionary={"auto":"AUTO","follow":"SEGUIR","retreat":"RECUAR"}
    var label:=str(labels.get(order_id,"AUTO"))
    action_buttons["companion_order"].text="ORDEM • "+label+"\nDefinir comportamento dos aliados"

func _choose(action_id: String) -> void:
    hide_menu()
    selected.emit(action_id)

func show_menu() -> void:
    visible = true
    root.modulate.a = 0.0
    var tw := create_tween()
    tw.tween_property(root, "modulate:a", 1.0, 0.14)

func hide_menu() -> void:
    visible = false
    closed.emit()

func is_open() -> bool:
    return visible
