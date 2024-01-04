extends Camera3D
class_name PlayerCamera

@export var body: Node3D
@export var sensitivity: float = 50
var x: float
var y: float

func _input(event):
	if event is InputEventMouseMotion:
		look_x(-event.relative.y / 1080.0 * sensitivity)
		look_y(-event.relative.x / 1920.0 * sensitivity)

func _process(_delta):
	basis = Basis()
	rotate_object_local(Vector3.RIGHT, deg_to_rad(x))
	global_rotate(body.global_basis.y, deg_to_rad(y))

func look_x(degrees: float):
	x += degrees
	if x > 90: x = 90
	elif x < -90: x = -90

func look_y(degrees: float):
	y += degrees
