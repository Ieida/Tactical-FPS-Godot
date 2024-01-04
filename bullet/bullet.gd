extends Node3D
class_name Bullet

@export var recoil: float
@export var damage: Damage

func hit(hitbox: Hitbox, point: Vector3, normal: Vector3):
	if hitbox.health:
		damage.apply_to(hitbox.health)
	hitbox.hit(point, normal)

func shoot() -> float:
	set_physics_process(false)
	$RayCast3D.force_raycast_update()
	var collider = $RayCast3D.get_collider()
	if collider:
		var point = $RayCast3D.get_collision_point()
		var normal = $RayCast3D.get_collision_normal()
		hit(collider as Hitbox, point, normal)
	queue_free()
	return recoil
