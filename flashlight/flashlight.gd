extends SpotLight3D

class_name Flashlight

@onready var light_cone: Node3D = $LightCone
@export var on_energy: float:
	set(value):
		on_energy = value
		if _is_on: light_energy = value

func _ready():
	light_energy = 0.0
	light_cone.hide()

var _is_on: bool = false
func toggle_flashlight():
	_is_on = not _is_on
	if _is_on:
		light_energy = on_energy
		light_cone.show()
	else:
		light_energy = 0
		light_cone.hide()
