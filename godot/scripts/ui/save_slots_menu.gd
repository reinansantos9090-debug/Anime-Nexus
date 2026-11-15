extends CanvasLayer
## Local save-slot selector. Existing slots are protected by an overwrite confirmation.

signal slot_loaded(slot_number:int)
signal closed

var save_service:Node
var game_state:Node
var root:Control
var slot_labels:Array[Label]=[]
var load_buttons:Array[Button]=[]
var save_buttons:Array[Button]=[]
var overwrite_dialog:ConfirmationDialog
var pending_slot:=-1

func _ready()->void:
    layer=26
    _build()
    hide_menu()

func setup(service:Node,state:Node)->void:
    save_service=service
    game_state=state
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
    title.text="ARQUIVO LOCAL • TRÊS ESPAÇOS"
    title.position=Vector2(30,22)
    title.add_theme_font_size_override("font_size",27)
    panel.add_child(title)
    var subtitle:=Label.new()
    subtitle.text="O progresso é local. Ao carregar, você retorna ao Observatório; substituir exige confirmação."
    subtitle.position=Vector2(32,62)
    subtitle.add_theme_font_size_override("font_size",15)
    panel.add_child(subtitle)
    for slot in range(3):
        var card:=Panel.new()
        card.position=Vector2(24,105+slot*112)
        card.size=Vector2(780,96)
        panel.add_child(card)
        var name:=Label.new()
        name.text="ESPAÇO %d"%(slot+1)
        name.position=Vector2(18,12)
        name.add_theme_font_size_override("font_size",19)
        card.add_child(name)
        var details:=Label.new()
        details.position=Vector2(18,43)
        details.size=Vector2(340,36)
        details.add_theme_font_size_override("font_size",14)
        card.add_child(details)
        slot_labels.append(details)
        var load_button:=Button.new()
        load_button.text="CARREGAR"
        load_button.position=Vector2(430,24)
        load_button.size=Vector2(145,48)
        load_button.pressed.connect(_load_slot.bind(slot))
        card.add_child(load_button)
        load_buttons.append(load_button)
        var save_button:=Button.new()
        save_button.text="SALVAR AQUI"
        save_button.position=Vector2(590,24)
        save_button.size=Vector2(165,48)
        save_button.pressed.connect(_request_save.bind(slot))
        card.add_child(save_button)
        save_buttons.append(save_button)
    var close_button:=Button.new()
    close_button.text="FECHAR"
    close_button.position=Vector2(620,455)
    close_button.size=Vector2(165,44)
    close_button.pressed.connect(hide_menu)
    panel.add_child(close_button)
    overwrite_dialog=ConfirmationDialog.new()
    overwrite_dialog.title="Substituir salvamento?"
    overwrite_dialog.confirmed.connect(_confirm_save)
    add_child(overwrite_dialog)

func _refresh()->void:
    if save_service==null or slot_labels.size()!=3:return
    for slot in range(3):
        var summary:Dictionary=save_service.slot_summary(slot)
        var has_save:=bool(summary.get("has_save",false))
        var compatible:=bool(summary.get("compatible",false))
        if compatible:
            var selected:=" • ATIVO" if int(save_service.active_slot)==slot else ""
            var recovery:=" • BACKUP" if str(summary.get("recovery_source",""))=="backup" else ""
            if bool(summary.get("protected_by_future_save",false)):recovery+=" • versão nova preservada"
            slot_labels[slot].text="Nível %d • capítulo %d%s%s"%[int(summary.get("level",1)),int(summary.get("chapter",1)),selected,recovery]
        elif bool(summary.get("future_schema",false)):
            slot_labels[slot].text="Salvamento de versão mais nova • Atualize o jogo"
        elif has_save:
            slot_labels[slot].text="Arquivo inválido • salvar exige confirmação"
        else:
            slot_labels[slot].text="Vazio"
        load_buttons[slot].disabled=not compatible
        save_buttons[slot].disabled=bool(summary.get("future_schema",false)) or bool(summary.get("protected_by_future_save",false))

func _load_slot(slot:int)->void:
    if save_service==null or not save_service.load_slot(slot):return
    hide_menu()
    slot_loaded.emit(slot+1)

func _request_save(slot:int)->void:
    if save_service==null:return
    pending_slot=slot
    var summary:Dictionary=save_service.slot_summary(slot)
    if bool(summary.get("has_save",false)):
        overwrite_dialog.dialog_text="O espaço %d contém progresso. Quer substituí-lo?"%(slot+1)
        overwrite_dialog.popup_centered()
    else:
        _confirm_save()

func _confirm_save()->void:
    if save_service==null or pending_slot<0:return
    if save_service.save_slot(pending_slot):
        pending_slot=-1
        _refresh()

func show_menu()->void:
    visible=true
    _refresh()
    root.modulate.a=0.0
    var tween:=create_tween()
    tween.tween_property(root,"modulate:a",1.0,0.14)

func hide_menu()->void:
    visible=false
    closed.emit()
