class_name Menu extends Control


signal closed


@export var transition_effect_duration: float = 0.2
@export var sub_menus: Dictionary


var active_sub_menu: Menu


func _init():
	scale = Vector2(0.8, 0.8)
	modulate = Color.TRANSPARENT
	hide()


func _on_active_sub_menu_closed():
	active_sub_menu = null
	open()


func close(emit_closed: bool = true):
	mouse_filter = Control.MOUSE_FILTER_STOP
	var t = create_tween().set_parallel(true)
	t.tween_property(self, "scale", Vector2(1.2, 1.2), transition_effect_duration)
	t.tween_property(self, "modulate", Color.TRANSPARENT, transition_effect_duration)
	await t.finished
	hide()
	if emit_closed:
		closed.emit()


func switch_to_sub_menu(sub_menu_name: StringName):
	if not sub_menus.has(sub_menu_name):
		printerr("No sub menu with name %s" % sub_menu_name)
	var sm = get_node(sub_menus[sub_menu_name])
	if active_sub_menu:
		await active_sub_menu.close()
	else:
		await close(false)
	active_sub_menu = sm
	if not active_sub_menu.closed.is_connected(_on_active_sub_menu_closed):
		active_sub_menu.closed.connect(_on_active_sub_menu_closed, CONNECT_ONE_SHOT)
	active_sub_menu.open()


func open():
	show()
	var t = create_tween().set_parallel(true)
	t.tween_property(self, "scale", Vector2.ONE, transition_effect_duration).from(Vector2(0.8, 0.8))
	t.tween_property(self, "modulate", Color.WHITE, transition_effect_duration).from(Color.TRANSPARENT)
	await t.finished
	mouse_filter = Control.MOUSE_FILTER_IGNORE
