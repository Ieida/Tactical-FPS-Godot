extends CharacterBody3D

@export var camera: PlayerCamera
@export var gravity: float = 9.8
@export var max_speed: float = 3
@export var speed: float = 3

var push_force = 0.8
func _physics_process(_delta):
	if not is_on_floor():
		velocity.y += -gravity
	
	var x = Input.get_axis("move_left", "move_right")
	var z = Input.get_axis("move_backward", "move_forward")
	var xv = camera.global_basis.x * x
	var zv = get_floor_normal().cross(camera.global_basis.x) * z
	var mv = (xv + zv).normalized() * speed
	velocity.x = mv.x
	velocity.z = mv.z
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
