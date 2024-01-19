extends Node3D

class_name Hitbox

signal hit_recieved(info: HitboxHitInfo)

@export var health: Health
@export var hit_particle_effects: PackedScene

func hit(info: HitboxHitInfo):
	if hit_particle_effects:
		var new_effect = hit_particle_effects.instantiate() as Node3D
		get_tree().root.add_child(new_effect)
		new_effect.global_position = info.point
		if info.normal.is_equal_approx(Vector3.UP):
			new_effect.rotate_x(deg_to_rad(90))
		elif info.normal.is_equal_approx(Vector3.DOWN):
			new_effect.rotate_x(deg_to_rad(-90))
		else:
			new_effect.look_at(info.point + info.normal)
		new_effect.orthonormalize()
	
	## Signal that a hit has be recieved
	hit_recieved.emit(info)
