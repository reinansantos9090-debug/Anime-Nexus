extends CanvasLayer
## Local roster selection for currently available companion prototypes.

signal selection_changed
signal closed

const MAX_COMPANIONS:=2
var game_state:Node
var content_database:Node
var root:Control
var selection_boxes:Dictionary={}
var status_label:Label

func _ready()->void:
    layer=22
    _build()
    hide_menu()

func setup(state:Node,content:Node)->void:
    game_state=state
    content_database=content
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
    panel.position=Vector2(225,76)
    panel.size=Vector2(830,560)
    root.add_child(panel)
    var title:=Label.new()
    title.text="FORMAÇÃO • ATÉ DOIS COMPANHEIROS"
    title.position=Vector2(30,24)
    title.add_theme_font_size_override("font_size",26)
    panel.add_child(title)
    var subtitle:=Label.new()
    subtitle.text="Escolha até dois aliados. Formação, papel e elemento ficam salvos offline."
    subtitle.position=Vector2(32,64)
    subtitle.add_theme_font_size_override("font_size",15)
    panel.add_child(subtitle)
    var list:=ScrollContainer.new()
    list.position=Vector2(24,105)
    list.size=Vector2(780,320)
    list.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
    panel.add_child(list)
    var rows:=VBoxContainer.new()
    rows.size_flags_horizontal=Control.SIZE_EXPAND_FILL
    rows.add_theme_constant_override("separation",5)
    list.add_child(rows)
    var list:=ScrollContainer.new()
    list.position=Vector2(24,105)
    list.size=Vector2(780,320)
    list.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
    panel.add_child(list)
    var rows:=VBoxContainer.new()
    rows.size_flags_horizontal=Control.SIZE_EXPAND_FILL
    rows.add_theme_constant_override("separation",5)
    list.add_child(rows)
    var ids:Array=[]
    if content_database:
        ids=content_database.COMPANIONS.keys()
        ids.sort()
    for value in ids:
        var id:=str(value)
        var data:Dictionary=content_database.COMPANIONS[id]
        var check:=CheckBox.new()
        var role_name:="Controle" if str(data.get("role",""))=="controller" else ("Suporte" if str(data.get("role",""))=="support" else "Ataque")
        check.text="%s • %s • %s"%(str(data.get("name",id)),str(data.get("element","")).to_upper(),role_name)
        check.custom_minimum_size=Vector2(750,48)
        check.add_theme_font_size_override("font_size",19)
        check.toggled.connect(_toggle_companion.bind(id))
        rows.add_child(check)
        selection_boxes[id]=check
    status_label=Label.new()
    status_label.position=Vector2(30,432)
    status_label.size=Vector2(550,40)
    status_label.add_theme_font_size_override("font_size",15)
    panel.add_child(status_label)
    var close_button:=Button.new()
    close_button.text="FECHAR"
    close_button.position=Vector2(620,493)
    close_button.size=Vector2(170,44)
    close_button.pressed.connect(hide_menu)
    panel.add_child(close_button)

func _normalized_selection(raw:Array)->Array:
    var result:Array=[]
    if content_database==null:return result
    for value in raw:
        var id:=str(value)
        if content_database.COMPANIONS.has(id) and id not in result:
            result.append(id)
            if result.size()>=MAX_COMPANIONS:break
    return result

func _toggle_companion(selected:bool,id:String)->void:
    if game_state==null:return
    var party:Dictionary=game_state.data.get("party",{}).duplicate(true)
    var chosen:=_normalized_selection(party.get("companions",[]))
    if selected and id not in chosen:
        if chosen.size()>=MAX_COMPANIONS:
            selection_boxes[id].set_pressed_no_signal(false)
            status_label.text="A formação já tem dois aliados."
            return
        chosen.append(id)
    elif not selected:
        chosen.erase(id)
    party["companions"]=chosen
    game_state.data["party"]=party
    game_state.state_changed.emit()
    _refresh()
    selection_changed.emit()

func _refresh()->void:
    if game_state==null or selection_boxes.is_empty():return
    var party:Dictionary=game_state.data.get("party",{})
    var chosen:=_normalized_selection(party.get("companions",[]))
    for id in selection_boxes.keys():
        selection_boxes[id].set_pressed_no_signal(str(id) in chosen)
    status_label.text="%d/%d aliados selecionados"%[chosen.size(),MAX_COMPANIONS]

func show_menu()->void:
    visible=true
    _refresh()
    root.modulate.a=0.0
    var tween:=create_tween()
    tween.tween_property(root,"modulate:a",1.0,0.14)

func hide_menu()->void:
    visible=false
    closed.emit()
