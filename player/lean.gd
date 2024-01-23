extends Node3D

enum {LEFT, RIGHT, NONE}

var side = NONE
@export var angle: float = 20
@export var distance: float = 0.1

func _process(delta):
	if Input.is_action_just_pressed("lean_right"):
		if side == RIGHT:
			rotation_degrees.z = 0
			position.x = 0
			side = NONE
		else:
			rotation_degrees.z = -angle
			position.x = distance
			side = RIGHT
	if Input.is_action_just_pressed("lean_left"):
		if side == LEFT:
			rotation_degrees.z = 0
			position.x = 0
			side = NONE
		else:
			rotation_degrees.z = angle
			position.x = -distance
			side = LEFT
