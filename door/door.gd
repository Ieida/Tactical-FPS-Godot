extends Node3D

@onready var joint: HingeJoint3D = $HingeJoint3D as HingeJoint3D
@onready var body: RigidBody3D = $RigidBody3D as RigidBody3D

func _ready():
	body.axis_lock_angular_y = true
	body.axis_lock_linear_x = true
	body.axis_lock_linear_y = true
	body.axis_lock_linear_z = true

func _physics_process(delta):
	if not is_closed and body.rotation_degrees.y < 0.1:
		is_closed = true
		body.axis_lock_angular_y = true
		body.axis_lock_linear_x = true
		body.axis_lock_linear_y = true
		body.axis_lock_linear_z = true
		print("is closed")
	elif is_closed and body.rotation_degrees.y > 0.1:
		is_closed = false
		print("is open")

func open_or_close():
	if is_closed: open()
	else: close()

var is_closed = true
func close():
	var trq = -body.rotation_degrees.y * 0.01
	body.apply_torque_impulse(Vector3(0, trq, 0))

func open():
	body.axis_lock_angular_y = false
	body.axis_lock_linear_x = false
	body.axis_lock_linear_y = false
	body.axis_lock_linear_z = false
	body.apply_torque_impulse(Vector3(0, 0.2, 0))
