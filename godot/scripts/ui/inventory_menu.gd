extends CanvasLayer
## Local inventory browser. Item quantities and currency come from the active offline save.

signal closed

var content_database:Node
var game_state:Node
var root:Control
var rows:VBoxContainer
var balance_label:Label

func _ready()->void:
    layer=27
    _build()
    hide_menu()

func setup(content:Node,state:Node)->void:
    content_database=content
    game_state=state
    if game_state and not game_state.inventory_changed.is_connected(_refresh):
        game_state.inventory_changed.connect(_refresh)
    _refresh()

func _build()->void:
    root=Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(root)
    var shade:=ColorRect.new()
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    shade.color=Color(0.01,0.02,0.05,0.84)
    root.add_child(shade)
    var panel:=Panel.new()
    panel.position=Vector2(250,70)
    panel.size=Vector2(780,580)
    root.add_child(panel)
    var title:=Label.new()
    title.text="BOLSA DE EXPLORADOR"
    title.position=Vector2(28,20)
    title.add_theme_font_size_override("font_size",26)
    panel.add_child(title)
    balance_label=Label.new()
    balance_label.position=Vector2(30,59)
    balance_label.size=Vector2(720,28)
    balance_label.add_theme_font_size_override("font_size",16)
    panel.add_child(balance_label)
    var scroll:=ScrollContainer.new()
    scroll.position=Vector2(24,100)
    scroll.size=Vector2(732,405)
    panel.add_child(scroll)
    rows=VBoxContainer.new()
    rows.size_flags_horizontal=Control.SIZE_EXPAND_FILL
    rows.add_theme_constant_override("separation",8)
    scroll.add_child(rows)
    var close_button:=Button.new()
    close_button.text="FECHAR"
    close_button.position=Vector2(540,520)
    close_button.size=Vector2(205,42)
    close_button.pressed.connect(hide_menu)
    panel.add_child(close_button)

func _refresh()->void:
    if rows==null or game_state==null:return
    for child in rows.get_children():
        rows.remove_child(child)
        child.queue_free()
    var hunter:Dictionary=game_state.get_hunter()
    balance_label.text="OURO %d   •   MATERIAIS, CONSUMÍVEIS E LICENÇAS LOCAIS"%int(hunter.get("gold",0))
    var values:Dictionary=game_state.get_inventory()
    var ids:Array=values.keys()
    ids.sort()
    var shown:=0
    for raw_id in ids:
        var id:=str(raw_id)
        var amount:=int(values[raw_id])
        if amount<=0:continue
        var data:Dictionary=content_database.ITEMS.get(id,{})
        var card:=PanelContainer.new()
        card.custom_minimum_size=Vector2(690,58)
        rows.add_child(card)
        var line:=HBoxContainer.new()
        line.add_theme_constant_override("separation",14)
        card.add_child(line)
        var name_label:=Label.new()
        name_label.text=str(data.get("name",id))
        name_label.size_flags_horizontal=Control.SIZE_EXPAND_FILL
        name_label.add_theme_font_size_override("font_size",16)
        line.add_child(name_label)
        var amount_label:=Label.new()
        amount_label.text="×%d"%amount
        amount_label.custom_minimum_size=Vector2(80,38)
        amount_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT
        amount_label.add_theme_font_size_override("font_size",17)
        line.add_child(amount_label)
        shown+=1
    if shown==0:
        var empty:=Label.new()
        empty.text="Sua bolsa está vazia. Materiais aparecem em expedições e recompensas."
        empty.custom_minimum_size=Vector2(690,72)
        rows.add_child(empty)

func show_menu()->void:
    _refresh()
    visible=true

func hide_menu()->void:
    visible=false
    closed.emit()
