class_name UIControls extends Menu


@export var action_container: Container
@export var scroll_container: ScrollContainer


func _ready():
	$MarginContainer/VBoxContainer/MenuButton.pressed.connect(_on_back_pressed)
	var ia = load("res://menus/controls/input_action/ui_input_action.tscn") as PackedScene
	var actns = InputMap.get_actions()
	actns = actns.filter(_filter_ui) as PackedStringArray
	actns.sort()
	for act in actns:
		var a = ia.instantiate() as UIInputAction
		a.action = act
		a.pressed.connect(_on_action_pressed)
		action_container.add_child(a)


func _filter_ui(a: StringName):
	return not a.begins_with("ui")


func _on_action_pressed(a: UIInputAction):
	scroll_container.ensure_control_visible(a)


func _on_back_pressed():
	back.emit()
