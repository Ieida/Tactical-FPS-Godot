extends RefCounted

class_name HitboxHitInfo

var point: Vector3
var normal: Vector3
var intensity: float
var damage: Damage

func _init(damage_: Damage, point_: Vector3 = Vector3.ZERO, normal_: Vector3 = Vector3.ZERO, intensity_: float = 0):
	point = point_
	normal = normal_
	intensity = intensity_
	damage = damage_
