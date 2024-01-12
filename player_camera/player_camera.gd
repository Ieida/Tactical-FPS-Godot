extends Camera3D

class_name PlayerCamera

class Shake extends RefCounted:
	var intensity: float
	var duration: float
	var _elapsed_time: float
	var _seed
	var noise: FastNoiseLite = FastNoiseLite.new()
	
	func _init():
		noise.seed = randi()
	
	func has_elapsed() -> bool:
		return _elapsed_time >= duration
	
	func update(delta: float) -> Vector2:
		_elapsed_time += delta
		
		var t = _elapsed_time * intensity
		var x = noise.get_noise_2d(t, 0)
		var y = noise.get_noise_2d(0, t)
		return Vector2(x, y)

class Recoil extends RefCounted:
	var amount: Vector2
	var duration: float
	var _elapsed_time: float
	var has_elapsed: bool = false
	
	func update(delta: float) -> Vector2:
		if not has_elapsed:
			_elapsed_time += delta
			has_elapsed = _elapsed_time >= duration
		
		return amount * delta / duration
	
	func ease_out_expo(x: float):
		return 1.0 if x == 1.0 else 1.0 - pow(2, -10.0 * x)
	
	func ease_out_elastic(x: float):
		const c4 = (2.0 * PI) / 3.0
		return 0.0 if x == 0.0 else 1.0 if x == 1.0 else pow(2, -10.0 * x) * sin((x * 10.0 - 0.75) * c4) + 1.0

@export var body: Node3D
@export var sensitivity: Sensitivity
var x: float
var y: float
@export var shake_intensity: float
var shakes: Array[Shake]
var _recoil: Array[Recoil]

func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		look_x(-event.relative.y / 1080.0 * sensitivity.value)
		look_y(-event.relative.x / 1920.0 * sensitivity.value)

func _process(_delta):
	basis = Basis()
	rotate_object_local(Vector3.RIGHT, deg_to_rad(x))
	global_rotate(body.global_basis.y, deg_to_rad(y))
	
	# Shake managment
	if shakes.size() > 0:
		var a = shakes.duplicate()
		for s in a:
			var v = s.update(_delta)
			if s.has_elapsed():
				shakes.erase(s)
			look_x(v.y)
			look_y(v.x)
	
	# Recoil management
	if _recoil.size() > 0:
		var a = _recoil.duplicate()
		for r in a:
			var v = r.update(_delta)
			if r.has_elapsed:
				_recoil.erase(r)
				Engine.time_scale = 1.0
			look_x(v.y)
			look_y(v.x)

func look_x(degrees: float):
	x += degrees
	if x > 90: x = 90
	elif x < -90: x = -90

func look_y(degrees: float):
	y += degrees

func shake(intensity: float, duration: float):
	var s = Shake.new()
	s.intensity = intensity
	s.duration = duration
	shakes.append(s)

func recoil(vector: Vector2, duration: float):
	var r := Recoil.new()
	r.amount = vector
	r.duration = duration
	_recoil.append(r)
	#Engine.time_scale = 0.01
