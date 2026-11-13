extends CanvasLayer
const JoystickScript=preload("res://scripts/ui/virtual_joystick.gd")
signal attack_pressed
signal ability_pressed(index: int)
signal portal_pressed
signal interact_pressed
signal inventory_pressed
signal story_pressed
signal wardrobe_pressed
signal dodge_pressed
signal menu_pressed
signal arsenal_pressed
signal gadget_pressed

var state: Node
var quests: Node
var title_label: Label
var stats_label: Label
var quest_label: Label
var move_vector := Vector2.ZERO
var move_stick: Control
var boss_panel: Panel
var boss_name: Label
var boss_bar: ProgressBar
var low_hp_overlay: ColorRect
var interact_button:Button

func setup(game_state: Node, quest_service: Node = null) -> void:
    state = game_state
    quests = quest_service
    _build()
    state.state_changed.connect(_refresh)
    state.quest_changed.connect(_refresh)
    _refresh()

func _build() -> void:
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(root)
    title_label = Label.new()
    title_label.position = Vector2(22,18)
    title_label.add_theme_font_size_override("font_size",24)
    root.add_child(title_label)
    stats_label = Label.new()
    stats_label.position = Vector2(22,58)
    root.add_child(stats_label)
    quest_label = Label.new()
    quest_label.position = Vector2(22,84)
    root.add_child(quest_label)
    low_hp_overlay=ColorRect.new()
    low_hp_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    low_hp_overlay.color=Color(0.82,0.08,0.10,0.0)
    low_hp_overlay.mouse_filter=Control.MOUSE_FILTER_IGNORE
    root.add_child(low_hp_overlay)
    _btn(root,"PORTAL",Vector2(760,24),Vector2(170,58)).pressed.connect(func(): portal_pressed.emit())
    _btn(root,"HISTÓRIA",Vector2(945,24),Vector2(170,58)).pressed.connect(func(): story_pressed.emit())
    interact_button=_btn(root,"INTERAGIR",Vector2(770,100),Vector2(190,58))
    interact_button.visible=false
    interact_button.pressed.connect(func():interact_pressed.emit())
    _btn(root,"MENU",Vector2(1000,105),Vector2(215,62)).pressed.connect(func(): menu_pressed.emit())
    _btn(root,"ATAQUE",Vector2(1000,515),Vector2(220,105)).pressed.connect(func(): attack_pressed.emit())
    _btn(root,"ESQUIVA",Vector2(1000,625),Vector2(220,65)).pressed.connect(func(): dodge_pressed.emit())
    _btn(root,"PASSO",Vector2(790,545),Vector2(78,78)).pressed.connect(func(): ability_pressed.emit(0))
    _btn(root,"CORR.",Vector2(875,505),Vector2(78,78)).pressed.connect(func(): ability_pressed.emit(1))
    _btn(root,"CAMPO",Vector2(875,595),Vector2(78,78)).pressed.connect(func(): ability_pressed.emit(2))
    move_stick=JoystickScript.new()
    move_stick.name="MoveJoystick"
    move_stick.position=Vector2(28,508)
    move_stick.size=Vector2(184,184)
    move_stick.vector_changed.connect(_set_move_vector)
    root.add_child(move_stick)
    boss_panel=Panel.new()
    boss_panel.position=Vector2(330,28)
    boss_panel.size=Vector2(390,78)
    boss_panel.visible=false
    root.add_child(boss_panel)
    boss_name=Label.new()
    boss_name.position=Vector2(18,8)
    boss_name.add_theme_font_size_override("font_size",16)
    boss_panel.add_child(boss_name)
    boss_bar=ProgressBar.new()
    boss_bar.position=Vector2(18,36)
    boss_bar.size=Vector2(354,20)
    boss_bar.show_percentage=false
    boss_panel.add_child(boss_bar)

func _set_move_vector(value: Vector2) -> void:
    move_vector=value

func _btn(parent: Control, text_value: String, pos: Vector2, size: Vector2) -> Button:
    var b := Button.new()
    b.text = text_value
    b.position = pos
    b.size = size
    b.add_theme_font_size_override("font_size",18)
    var normal:=StyleBoxFlat.new()
    normal.bg_color=Color("#162235d9")
    normal.border_color=Color("#5bcfff88")
    normal.set_border_width_all(1)
    normal.set_corner_radius_all(14)
    var hover:=normal.duplicate()
    hover.bg_color=Color("#24405fdc")
    b.add_theme_stylebox_override("normal",normal)
    b.add_theme_stylebox_override("hover",hover)
    b.add_theme_stylebox_override("pressed",hover)
    parent.add_child(b)
    return b

func set_mode(value: String) -> void:
    if title_label:
        title_label.text = value

func _refresh() -> void:
    if state == null:
        return
    var h: Dictionary = state.data["hunter"]
    title_label.text = "ANIME NEXUS • KAIEN ARASHI"
    stats_label.text = "HP %d/%d  |  LV %d  |  XP %d/%d  |  EN %d/%d" % [int(h["hp"]),int(h["max_hp"]),int(h["level"]),int(h["xp"]),int(h["xp_to_next"]),int(h["energy"]),int(h["max_energy"])]
    quest_label.text = "Missão: nenhum" if quests == null else "Missão: "+quests.active_summary()
    if low_hp_overlay:
        var ratio:=float(h["hp"])/maxf(1.0,float(h["max_hp"]))
        low_hp_overlay.color.a=clampf((0.32-ratio)*1.6,0.0,0.34)

func set_boss(name_value:String,ratio:float,phase:int)->void:
    if boss_panel==null:return
    boss_panel.visible=true
    boss_name.text="%s • FASE %d" % [name_value,phase]
    boss_bar.value=clampf(ratio,0.0,1.0)*100.0

func clear_boss()->void:
    if boss_panel: boss_panel.visible=false

func set_interaction_visible(value:bool)->void:
    if interact_button:interact_button.visible=value
