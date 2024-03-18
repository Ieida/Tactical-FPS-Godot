extends Weapon

class_name Grenade

@export var time_to_explode: float = 5.0
@onready var rb: RigidBody3D = $RigidBody3D as RigidBody3D
@export var explosion_effect: PackedScene
@export var damage: Damage
@export var radius: float = 10
@onready var effect_area: Area3D = $RigidBody3D/EffectArea

func _ready():
	rb.freeze = true
	$RigidBody3D/EffectArea/CollisionShape3D.shape.radius = radius

func _explode():
	for area in effect_area.get_overlapping_areas():
		area = area as Node3D
		if area is Node3D:
			var a = area as Node3D
			if a is Hitbox:
				var d = calculate_damage(damage.amount, global_position.distance_to(a.global_position))
				var pd = damage.amount
				damage.amount = d
				var info = HitboxHitInfo.new(damage, Vector3.ZERO, Vector3.ZERO, 1)
				area.hit(info)
				damage.amount = pd
	
	var ee = explosion_effect.instantiate()
	get_tree().root.add_child(ee)
	ee.global_position = rb.global_position
	queue_free()

func add_collision_exception_with(body: Node):
	rb.add_collision_exception_with(body)

func calculate_damage(initial: float, distance: float) -> float:
	return initial * clampf(1 - (distance / radius), 0, 1)

func release_spoon():
	await get_tree().create_timer(time_to_explode).timeout
	_explode()

func throw(impulse: Vector3):
	rb.freeze = false
	rb.apply_central_impulse(impulse)
