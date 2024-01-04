extends Node
class_name CameraController

@export var camera: Camera3D
@export var body: Node3D

func _process(delta):
	pass

func rotate_x(degrees: float):
	var angle = body.global_basis.y.signed_angle_to(camera.global_basis.y, body.global_basis.y)
	angle = rad_to_deg(angle)
	var p = 1.0 - clampf(absf(angle) / 90.0, 0, 1)
	degrees -= degrees * clampf(absf(1.0 - p), 0, 1)
	print("%s, %s" % [p, degrees])
	camera.rotate_object_local(Vector3.RIGHT, deg_to_rad(degrees))
	camera.orthonormalize()

func rotate_y(degrees: float):
	camera.global_rotate(body.global_basis.y, deg_to_rad(degrees))
	camera.orthonormalize()
