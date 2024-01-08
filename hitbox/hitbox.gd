extends Node3D

class_name Hitbox

@export var health: Health
@export var hit_particle_effects: PackedScene

func hit(point: Vector3, normal: Vector3):
	var new_effect = hit_particle_effects.instantiate() as Node3D
	get_tree().root.add_child(new_effect)
	new_effect.global_position = point
	if normal.is_equal_approx(Vector3.UP):
		new_effect.rotate_x(deg_to_rad(90))
	elif normal.is_equal_approx(Vector3.DOWN):
		new_effect.rotate_x(deg_to_rad(-90))
	else:
		new_effect.look_at(point + normal)
	new_effect.orthonormalize()
