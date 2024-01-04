extends Node
class_name Nausea

@export var camera: PlayerCamera
@export_category("Stroke")
@export var length: float
@export var duration: float
var axis: Vector3 = Vector3.UP
var elapsed_time: float
var velocity: Vector2 = Vector2.UP
@export var speed: float = 30
@export var angle: float = 135

func _process(delta):
	elapsed_time += delta
	if elapsed_time >= duration:
		elapsed_time = 0
		axis = get_new_axis()
	
	velocity = velocity.normalized().rotated(deg_to_rad(-angle * delta)) * speed
	#var s = length / duration
	#var t = (duration) + 0.5
	#var amt = s * t * delta
	camera.look_x(velocity.x * delta)
	camera.look_y(velocity.y * delta)

func get_new_axis() -> Vector3:
	return -axis.rotated(Vector3.FORWARD, deg_to_rad(randf_range(0, 360))).normalized()
