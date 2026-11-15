extends CanvasLayer
## Local crafting station. Recipes and inventory are resolved on device.

signal crafted(recipe_id:String,success:bool)
signal closed

var content_database:Node
var inventory_service:Node
var root:Control
var cards:VBoxContainer
var status_label:Label

func _ready()->void:
    layer=25
    _build()
    hide_menu()

func setup(content:Node,inventory:Node)->void:
    content_database=content
    inventory_service=inventory
    if inventory_service and not inventory_service.changed.is_connected(_refresh):
        inventory_service.changed.connect(_refresh)
    _refresh()

func _build()->void:
    root=Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(root)
    var shade:=ColorRect.new()
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    shade.color=Color(0.01,0.02,0.05,0.86)
    root.add_child(shade)
    var panel:=Panel.new()
    panel.position=Vector2(170,70)
    panel.size=Vector2(940,580)
    root.add_child(panel)
    var title:=Label.new()
    title.text="OFICINA DAS RESSONÂNCIAS • MEKA"
    title.position=Vector2(28,20)
    title.add_theme_font_size_override("font_size",25)
    panel.add_child(title)
    var subtitle:=Label.new()
    subtitle.text="Receitas locais • Materiais são conferidos antes de qualquer débito."
    subtitle.position=Vector2(30,58)
    subtitle.add_theme_font_size_override("font_size",15)
    panel.add_child(subtitle)
    var scroll:=ScrollContainer.new()
    scroll.position=Vector2(24,95)
    scroll.size=Vector2(892,350)
    panel.add_child(scroll)
    cards=VBoxContainer.new()
    cards.size_flags_horizontal=Control.SIZE_EXPAND_FILL
    cards.add_theme_constant_override("separation",10)
    scroll.add_child(cards)
    status_label=Label.new()
    status_label.position=Vector2(28,455)
    status_label.size=Vector2(620,42)
    status_label.add_theme_font_size_override("font_size",16)
    panel.add_child(status_label)
    var close_button:=Button.new()
    close_button.text="FECHAR"
    close_button.position=Vector2(710,505)
    close_button.size=Vector2(190,42)
    close_button.pressed.connect(hide_menu)
    panel.add_child(close_button)

func _format_costs(items:Dictionary)->String:
    if items.is_empty():return "—"
    var parts:Array[String]=[]
    var ids:Array=items.keys()
    ids.sort()
    for raw_id in ids:
        var id:=str(raw_id)
        var data:Dictionary=content_database.ITEMS.get(id,{})
        parts.append("%s ×%d (possui %d)"%[str(data.get("name",id)),int(items[raw_id]),inventory_service.quantity(id)])
    return ", ".join(parts)

func _format_items(items:Dictionary)->String:
    if items.is_empty():return "—"
    var parts:Array[String]=[]
    var ids:Array=items.keys()
    ids.sort()
    for raw_id in ids:
        var id:=str(raw_id)
        var data:Dictionary=content_database.ITEMS.get(id,{})
        parts.append("%s ×%d"%[str(data.get("name",id)),int(items[raw_id])])
    return ", ".join(parts)

func _refresh()->void:
    if cards==null:return
    for child in cards.get_children():
        cards.remove_child(child)
        child.queue_free()
    if content_database==null or inventory_service==null:return
    for recipe in content_database.RECIPES:
        var recipe_id:=str(recipe.get("id",""))
        var card:=PanelContainer.new()
        card.custom_minimum_size=Vector2(860,82)
        cards.add_child(card)
        var row:=HBoxContainer.new()
        row.add_theme_constant_override("separation",14)
        card.add_child(row)
        var details:=VBoxContainer.new()
        details.size_flags_horizontal=Control.SIZE_EXPAND_FILL
        row.add_child(details)
        var name_label:=Label.new()
        name_label.text=str(recipe.get("name",recipe_id))
        name_label.add_theme_font_size_override("font_size",18)
        details.add_child(name_label)
        var cost_label:=Label.new()
        cost_label.text="Exige: "+_format_costs(recipe.get("requires",{}))
        cost_label.add_theme_font_size_override("font_size",13)
        details.add_child(cost_label)
        var result_label:=Label.new()
        result_label.text="Produz: "+_format_items(recipe.get("result",{}))
        result_label.add_theme_font_size_override("font_size",13)
        details.add_child(result_label)
        var craft_button:=Button.new()
        craft_button.custom_minimum_size=Vector2(150,48)
        var unlock_weapon:=str(recipe.get("unlock_weapon",""))
        var unlocked:=not unlock_weapon.is_empty() and inventory_service.quantity("weapon_license_"+unlock_weapon)>0
        craft_button.text="DESBLOQUEADO" if unlocked else "CRIAR"
        craft_button.disabled=unlocked or not inventory_service.has_cost(recipe.get("requires",{}))
        craft_button.pressed.connect(_craft.bind(recipe_id))
        row.add_child(craft_button)

func _craft(recipe_id:String)->void:
    var success:=inventory_service.craft_by_id(recipe_id,content_database)
    if success:
        status_label.text="CRIADO • "+_recipe_name(recipe_id)
    else:
        status_label.text="MATERIAIS INSUFICIENTES • NENHUM ITEM FOI DEBITADO"
    crafted.emit(recipe_id,success)

func _recipe_name(recipe_id:String)->String:
    for recipe in content_database.RECIPES:
        if str(recipe.get("id",""))==recipe_id:return str(recipe.get("name",recipe_id))
    return recipe_id

func show_menu()->void:
    visible=true
    _refresh()

func hide_menu()->void:
    visible=false
    closed.emit()
