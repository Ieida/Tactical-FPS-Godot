extends Node3D

enum {LEFT, RIGHT, NONE}

var side = NONE
@export var angle: float = 5
@export var distance: float = 0.3
@onready var camera: Node3D = $PlayerCamera
var tween: Tween


func _unhandled_input(event):
	if event.is_action_pressed("lean_right"):
		lean_right()
	elif event.is_action_pressed("lean_left"):
		lean_left()


func lean_left():
	if side == LEFT:
		if tween: tween.stop()
		tween = create_tween().set_parallel(true)
		tween.tween_property(self, "rotation_degrees:z", 0, 0.5)
		tween.tween_property(camera, "position:x", 0, 0.5)
		side = NONE
	else:
		if tween: tween.stop()
		tween = create_tween().set_parallel(true)
		tween.tween_property(self, "rotation_degrees:z", angle, 0.5)
		tween.tween_property(camera, "position:x", -distance, 0.5)
		side = LEFT


func lean_right():
	if side == RIGHT:
		if tween: tween.stop()
		tween = create_tween().set_parallel(true)
		tween.tween_property(self, "rotation_degrees:z", 0, 0.5)
		tween.tween_property(camera, "position:x", 0, 0.5)
		side = NONE
	else:
		if tween: tween.stop()
		tween = create_tween().set_parallel(true)
		tween.tween_property(self, "rotation_degrees:z", -angle, 0.5)
		tween.tween_property(camera, "position:x", distance, 0.5)
		side = RIGHT
