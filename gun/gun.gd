extends Weapon

class_name Gun

enum FireMode {SINGLE, SEMI, BURST, AUTO}

signal recoil(vector: Vector2)

@export var magazine: Magazine
@export var muzzle: Node3D
@export var _rpm: float
@export var fire_mode: FireMode = FireMode.SINGLE
@export_range(0.0, 1.0) var recoil_multiplier: float
@export var sideways_recoil_min: float
@export var sideways_recoil_max: float
@export_range(0.0, 1.0) var spread_multiplier: float
@export var muzzle_flash: PackedScene
var _chambered_bullet: Bullet
var _time_since_last_shot: float
var _time_between_shots: float
var is_slide_resting: bool
var is_slide_lock_activated: bool

func _ready():
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
				_drop_hammer()

func activate_slide_lock():
	is_slide_lock_activated = true

func deactivate_slide_lock():
	is_slide_lock_activated = false
	if not is_slide_resting: _drop_slide()

func set_rpm(value: float):
	_rpm = value
	_time_between_shots = 60.0 / _rpm

var is_trigger_pressed = false
func press_trigger():
	is_trigger_pressed = true
	_drop_hammer()

func release_trigger():
	is_trigger_pressed = false

func _drop_hammer():
	if is_slide_resting:
		_shoot_bullet()

func _shoot_bullet():
	if not _chambered_bullet: return
	
	# Muzzle flash
	var new_muzzle_flash = muzzle_flash.instantiate()
	muzzle.add_child(new_muzzle_flash)
	new_muzzle_flash.global_transform = muzzle.global_transform
	new_muzzle_flash.start()
	
	# Spread
	var sprd = _chambered_bullet.spread * spread_multiplier * 45.0
	_chambered_bullet.rotate_object_local(Vector3.BACK, deg_to_rad(randf_range(-180.0, 180.0)))
	_chambered_bullet.rotate_object_local(Vector3.UP, deg_to_rad(sprd))
	
	var rcl_amt = _chambered_bullet.shoot()
	_chambered_bullet = null
	
	## Push the slide back
	if fire_mode != FireMode.SINGLE:
		await push_slide()
	
	## Apply recoil
	rcl_amt *= recoil_multiplier
	var rcl_v = Vector2(randf_range(sideways_recoil_min, sideways_recoil_max), rcl_amt)
	recoil.emit(rcl_v)
	
	## Drop the slide
	if not is_slide_resting:
		_drop_slide()

func push_slide():
	if is_slide_resting:
		is_slide_resting = false
		await get_tree().create_timer(_time_between_shots / 3.0).timeout
	
	if not is_slide_lock_activated:
		await _drop_slide()

func _drop_slide():
	if is_slide_lock_activated: return
	
	var next_bullet = null
	if magazine:
		next_bullet = magazine.unload_bullet()
		if not next_bullet:
			activate_slide_lock()
			return
	
	await get_tree().create_timer(_time_between_shots / 1.5).timeout
	if _chambered_bullet: return
	_chambered_bullet = next_bullet
	is_slide_resting = true

func unload_magazine() -> Magazine:
	var mag = magazine
	magazine = null
	return mag

func load_magazine(mag: Magazine):
	magazine = mag
