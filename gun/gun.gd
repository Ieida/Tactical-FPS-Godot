extends Weapon
class_name Gun

enum FireMode {SINGLE, BURST, AUTO}

signal recoil(vector: Vector2)

@export var magazine: Magazine
@export var muzzle: Node3D
@export var _rpm: float
@export var fire_mode: FireMode = FireMode.SINGLE
@export_range(0.0, 1.0) var recoil_multiplier: float
@export var sideways_recoil_min: float
@export var sideways_recoil_max: float
@export_range(0.0, 1.0) var spread_multiplier: float
@export var muzzle_flash: GPUParticles3D
var _chambered_bullet: Bullet
var _time_since_last_shot: float
var _time_between_shots: float
var is_locked: bool

func _ready():
	_chambered_bullet = magazine.unload_bullet()
	_time_between_shots = 60.0 / _rpm

func _process(delta):
	if _time_since_last_shot < _time_between_shots:
		_time_since_last_shot += delta
	
	match fire_mode:
		FireMode.BURST:
			if is_trigger_pressed:
				pass
		FireMode.AUTO:
			if is_trigger_pressed:
				_shoot()

func set_rpm(value: float):
	_rpm = value
	_time_between_shots = 60.0 / _rpm

var is_trigger_pressed = false
func press_trigger():
	is_trigger_pressed = true
	_shoot()

func release_trigger():
	is_trigger_pressed = false

func _shoot():
	if _time_since_last_shot < _time_between_shots or is_locked: return
	_time_since_last_shot = 0
	
	if _chambered_bullet:
		_shoot_bullet()

func _shoot_bullet():
	# Muzzle flash
	muzzle_flash.restart()
	
	# Spread
	var sprd = _chambered_bullet.spread * spread_multiplier * 45.0
	_chambered_bullet.rotate_object_local(Vector3.BACK, deg_to_rad(randf_range(-180.0, 180.0)))
	_chambered_bullet.rotate_object_local(Vector3.UP, deg_to_rad(sprd))
	
	var rcl_amt = _chambered_bullet.shoot()
	rcl_amt *= recoil_multiplier
	var rcl_v = Vector2(randf_range(sideways_recoil_min, sideways_recoil_max), rcl_amt)
	recoil.emit(rcl_v)
	if magazine:
		_chambered_bullet = magazine.unload_bullet()
	else:
		_chambered_bullet = null

func rack_slide():
	if is_locked and not magazine:
		is_locked = false
	elif _chambered_bullet and magazine:
		is_locked = true
	elif not _chambered_bullet and magazine:
		_chambered_bullet = magazine.unload_bullet()

func unload_magazine() -> Magazine:
	var mag = magazine
	magazine = null
	return mag

func load_magazine(mag: Magazine):
	magazine = mag
