extends Weapon
class_name Gun

signal recoil(amount: float)

@export var magazine: Magazine
@export var muzzle: Node3D
@export var _rpm: float
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

func set_rpm(value: float):
	_rpm = value
	_time_between_shots = 60.0 / _rpm

func press_trigger():
	if _time_since_last_shot < _time_between_shots or is_locked: return
	_time_since_last_shot = 0
	
	if _chambered_bullet:
		_shoot_bullet()

func _shoot_bullet():
	var rcl = _chambered_bullet.shoot()
	recoil.emit(rcl)
	_chambered_bullet = magazine.unload_bullet()

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
