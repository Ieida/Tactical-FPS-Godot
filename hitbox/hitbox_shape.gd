extends CollisionShape3D
class_name HitboxShape

@export var target: Node3D

func _physics_process(delta):
	if target:
		global_position = target.global_position
