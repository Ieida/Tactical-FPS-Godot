extends CharacterBody3D


@export var camera: PlayerCamera
@export var gravity: float = 9.8
@export var max_speed: float = 3
@export var speed: float = 3
@export var run_speed: float


var move_input: Vector2
var push_force = 0.8


func _unhandled_input(event):
	if event.is_action("move_left") or event.is_action("move_right") or event.is_action("move_backward") or event.is_action("move_forward"):
		move_input = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")


func _physics_process(_delta):
	if not is_on_floor():
		velocity.y += -gravity * _delta
	
	var ipt = move_input
	var flr = get_floor_normal()
	var fwd = flr.cross(camera.global_basis.x)
	var rht = fwd.cross(flr)
	var dir = ((rht * ipt.x) + (fwd * ipt.y)).normalized()
	var spd = run_speed if Input.is_action_pressed("run") else speed
	if dir and is_on_floor():
		velocity.x = dir.x * spd
		velocity.z = dir.z * spd
	elif is_on_floor():
		var ax = absf(velocity.x)
		var az = absf(velocity.z)
		var vx = clampf(ax, 3, ax)
		var vz = clampf(az, 3, az)
		velocity.x = move_toward(velocity.x, 0, vx * _delta)
		velocity.z = move_toward(velocity.z, 0, vz * _delta)
	
	move_and_slide()
	
	
	# Temporary, for door interactions
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
