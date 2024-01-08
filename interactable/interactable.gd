extends Area3D

class_name Interactable

signal interacted

func _ready():
	hide()

func interact():
	interacted.emit()
