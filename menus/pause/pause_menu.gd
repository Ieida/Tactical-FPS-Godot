class_name PauseMenu extends Menu


@export var background: CanvasLayer
@export var controls: GameMenuButton


func _ready():
	hide()
	background.hide()
	controls.pressed.connect(_on_controls_pressed)
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


func _on_controls_pressed():
	switch_to_sub_menu(&"controls")


func abandon():
	hide()
	get_tree().change_scene_to_file("res://menus/main/main_menu.tscn")


func pause():
	background.show()
	open()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func resume():
	close()
	background.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
