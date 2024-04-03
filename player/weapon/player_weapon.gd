extends Node3D

class_name PlayerWeapon

@export var weapon: Weapon
@export var camera: PlayerCamera
@export var animation_player: AnimationPlayer

func _ready():
	pass

func _process(_delta):
	pass

func can_holster() -> bool:
	return false

var is_holstered: bool = false
func holster():
	is_holstered = true
	animation_player.play("holster")
	await animation_player.animation_finished
	hide()

func unholster():
	show()
	animation_player.play("unholster")
	await animation_player.animation_finished
	animation_player.play("idle")
	is_holstered = false
