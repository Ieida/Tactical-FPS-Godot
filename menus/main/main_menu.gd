class_name MainMenu extends Menu


@export var controls: GameMenuButton
@export var mission_select: GameMenuButton
@export var settings: GameMenuButton
@export var quit: GameMenuButton


func _ready():
	controls.pressed.connect(_on_controls_pressed)
	mission_select.pressed.connect(_on_mission_select_pressed)
	settings.pressed.connect(_on_settings_pressed)
	quit.pressed.connect(_on_quit_pressed)
	open()


func _on_controls_pressed():
	switch_to_sub_menu(&"controls")


func _on_mission_select_pressed():
	switch_to_sub_menu(&"mission_select")


func _on_settings_pressed():
	switch_to_sub_menu(&"settings")


func _on_quit_pressed():
	get_tree().quit()
