class_name UIInputAction extends PanelContainer


signal pressed


@export var event_container: Container


var action: StringName


func _ready():
	$MarginContainer/VBoxContainer/Name.text = action.capitalize()
	var ie = load("res://menus/controls/input_action/ui_input_event.tscn") as PackedScene
	for evnt in InputMap.action_get_events(action):
		var e = ie.instantiate() as UIInputEvent
		e.event = evnt
		event_container.add_child(e)


func _input(event):
	if event.is_action_pressed(action):
		pressed.emit(self)
