extends Node3D

class_name Laser

@onready var raycast: RayCast3D = $RayCast3D
@onready var line: MeshInstance3D = $Line
@onready var spot: MeshInstance3D = $Spot
@export_category("Noise")
@export var noise: FastNoiseLite
@export var scroll_speed: float

func _ready():
	hide()
	is_on = false

func _process(delta):
	noise.offset += Vector3.ONE * scroll_speed * delta
	
	raycast.force_raycast_update()
	var distance = 50.0
	var point = to_global(Vector3.FORWARD * distance)
	var normal = point.direction_to(global_position)
	var local_point = Vector3.FORWARD * distance
	if raycast.is_colliding():
		point = raycast.get_collision_point()
		normal = raycast.get_collision_normal()
		local_point = to_local(point)
		distance = absf(local_point.z)
	
	spot.global_position = point + (normal * 0.01)
	if rad_to_deg(Vector3.UP.angle_to(normal)) < 15.0:
		spot.global_rotation_degrees = Vector3(-90, 0, 0)
	else:
		spot.look_at(point + -normal)
	spot.orthonormalize()
	spot.scale = Vector3.ONE * remap(distance / 50.0, 0, 1, 0.01, 0.15)
	
	line.position.z = -distance / 2.0
	line.scale.y = distance

var is_on: bool
func toggle_laser():
	is_on = !is_on
	if is_on: show()
	else: hide()
