extends Weapon

class_name Grenade

@export var time_to_explode: float = 5.0
@onready var rb: RigidBody3D = $RigidBody3D as RigidBody3D
@export var explosion_effect: PackedScene

func _ready():
	rb.freeze = true

func _explode():
	for body in $RigidBody3D/Area3D.get_overlapping_bodies():
		# Deal damage
		pass
	
	var ee = explosion_effect.instantiate()
	get_tree().root.add_child(ee)
	ee.global_position = rb.global_position
	queue_free()

func add_collision_exception_with(body: Node):
	rb.add_collision_exception_with(body)

func release_spoon():
	await get_tree().create_timer(time_to_explode).timeout
	_explode()

func throw(impulse: Vector3):
	rb.freeze = false
	rb.apply_central_impulse(impulse)
