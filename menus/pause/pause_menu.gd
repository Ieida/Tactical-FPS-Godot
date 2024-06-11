class_name PauseMenu extends Menu


func _ready():
	hide()
	$VBoxContainer/Resume.pressed.connect(resume)
	$VBoxContainer/Abandon.pressed.connect(abandon)


func _unhandled_input(event):
	if is_visible_in_tree():
		get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("ui_cancel"):
		if is_visible_in_tree():
			resume()
		else:
			pause()


func abandon():
	hide()
	get_tree().change_scene_to_file("res://menus/main/main_menu.tscn")


func close():
	var t = create_tween().set_parallel(true)
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	await t.finished
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func pause():
	show()
	open()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func resume():
	await close()
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
