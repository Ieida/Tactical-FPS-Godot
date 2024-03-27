extends Camera3D

class_name PlayerCamera

class Shake extends RefCounted:
	var duration: float
	var length: float
	var ease_value: float
	var _elapsed_time: float
	var _stroke_duration: float
	var _stroke_vector: Vector2
	
	func _init(intensity: float, ease_value_: float):
		duration = intensity
		length = exp(intensity) * 2.0
		_stroke_duration = duration / exp(intensity)
		ease_value = ease_value_
		_stroke_vector = Vector2.UP.rotated(deg_to_rad(randf() * 360.0))
	
	func has_elapsed() -> bool:
		return _elapsed_time >= duration
	
	func update(delta: float) -> Vector2:
		_elapsed_time += delta
		
		var c = floorf(_elapsed_time / _stroke_duration) ## amount of strokes elapsed
		var b = (_elapsed_time - (_stroke_duration * c)) / _stroke_duration
		var t = _elapsed_time / (_stroke_duration * c)
		if t >= 1.0:
			_stroke_vector = Vector2.UP.rotated(deg_to_rad(randf() * 360.0))
		var l = length * remap(b, 0, 1, -1, 1)
		var v = _stroke_vector
		return v * l * ease(1 - (_elapsed_time / duration), ease_value)

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
var x: float
var y: float
@export var shake_intensity: float
var shakes: Array[Shake]
var _recoil: Array[Recoil]

func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		var s = Settings.get_setting("sensitivity")
		if not s: s = 0
		look_x(-event.relative.y * s)
		look_y(-event.relative.x * s)

func _process(_delta):
	basis = Basis()
	rotate_object_local(Vector3.RIGHT, deg_to_rad(x))
	get_parent().global_rotate(body.global_basis.y, deg_to_rad(y))
	y = 0
	
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
	y = degrees

func shake(intensity: float, ease_value: float):
	var s = Shake.new(intensity, ease_value)
	shakes.append(s)

func recoil(vector: Vector2, duration: float):
	var r := Recoil.new()
	r.amount = vector
	r.duration = duration
	_recoil.append(r)
	#Engine.time_scale = 0.01
