extends Node3D
class_name Bullet

@export var recoil: float
@export_range(0.0, 1.0) var spread: float
@export var damage: Damage
@export var shrapnel_effect: PackedScene

func hit(hitbox: Hitbox, point: Vector3, normal: Vector3):
	if hitbox.health:
		damage.apply_to(hitbox.health)
	hitbox.hit(point, normal)

func shoot() -> float:
	set_physics_process(false)
	$RayCast3D.force_raycast_update()
	var collider = $RayCast3D.get_collider()
	var point = $RayCast3D.get_collision_point()
	var normal = $RayCast3D.get_collision_normal()
	if collider:
		var se = shrapnel_effect.instantiate()
		get_tree().root.add_child(se)
		se.global_position = point
		if normal.is_equal_approx(Vector3.UP):
			se.rotate_x(deg_to_rad(90))
		elif normal.is_equal_approx(Vector3.DOWN):
			se.rotate_x(deg_to_rad(-90))
		else:
			se.look_at(point + normal)
		se.orthonormalize()
	if collider is Hitbox:
		hit(collider, point, normal)
	queue_free()
	return recoil
