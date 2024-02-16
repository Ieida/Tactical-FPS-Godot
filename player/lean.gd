extends Node3D

enum {LEFT, RIGHT, NONE}

var side = NONE
@export var angle: float = 10
@onready var camera: Node3D = $PlayerCamera

func _process(delta):
	if Input.is_action_just_pressed("lean_right"):
		if side == RIGHT:
			rotation_degrees.z = 0
			camera.position.x = 0
			side = NONE
		else:
			rotation_degrees.z = -angle
			camera.position.x = 0.2
			side = RIGHT
	if Input.is_action_just_pressed("lean_left"):
		if side == LEFT:
			rotation_degrees.z = 0
			camera.position.x = 0
			side = NONE
		else:
			rotation_degrees.z = angle
			camera.position.x = -0.2
			side = LEFT
