extends Area3D

class_name Interactable

signal interacted

func _ready():
	hide()

func disable():
	hide()
	set_collision_layer_value(4, false)

func enable():
	show()
	set_collision_layer_value(4, true)

func interact():
	interacted.emit()
