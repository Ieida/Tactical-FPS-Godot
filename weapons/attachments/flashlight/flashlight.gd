extends SpotLight3D

class_name Flashlight

@export var on_energy: float:
	set(value):
		on_energy = value
		if _is_on: light_energy = value

func _ready():
	light_energy = 0.0

var _is_on: bool = false
func toggle_flashlight():
	_is_on = not _is_on
	if _is_on:
		light_energy = on_energy
	else:
		light_energy = 0
