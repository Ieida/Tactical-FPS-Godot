class_name Gun extends Weapon


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
var is_slide_resting: bool
var is_slide_lock_activated: bool
var fire_timer: Timer
var is_trigger_pressed: bool
var is_trigger_reset: bool = true


func _ready():
	fire_timer = Timer.new()
	fire_timer.one_shot = true
	add_child(fire_timer, false, Node.INTERNAL_MODE_FRONT)
	set_rpm(_rpm)


func _process(_delta):
	match fire_mode:
		FireMode.SINGLE:
			_process_single(_delta)
		FireMode.SEMI:
			_process_semi(_delta)
		FireMode.BURST:
			_process_burst(_delta)
		FireMode.AUTO:
			_process_auto(_delta)


func _process_single(_dt: float):
	pass


func _process_semi(_dt: float):
	if is_trigger_pressed and is_trigger_reset and is_zero_approx(fire_timer.time_left):
		is_trigger_reset = false
		fire()


func _process_burst(_dt: float):
	pass


func _process_auto(_dt: float):
	if is_trigger_pressed and is_zero_approx(fire_timer.time_left):
		is_trigger_reset = false
		fire()


func _chamber_bullet():
	_chambered_bullet = magazine.unload_bullet()
	_chambered_bullet.reparent(muzzle)
	_chambered_bullet.position = Vector3.ZERO
	_chambered_bullet.rotation = Vector3.ZERO


func activate_slide_lock():
	is_slide_lock_activated = true


func deactivate_slide_lock():
	is_slide_lock_activated = false


func fire():
	if not _chambered_bullet: return
	
	# Spread
	var sprd = deg_to_rad(_chambered_bullet.spread * spread_multiplier)
	var vctr = Vector3.UP.rotated(Vector3.FORWARD, deg_to_rad(randf_range(0, 360)))
	_chambered_bullet.rotate_object_local(vctr, randf_range(0, sprd))
	
	var rcl = _chambered_bullet.shoot()
	_chambered_bullet = null
	fire_timer.start()
	if magazine and magazine.get_bullet_count() > 0:
		_chamber_bullet()
	
	# Recoil
	rcl *= recoil_multiplier
	var rcl_v = Vector2(randf_range(sideways_recoil_min, sideways_recoil_max), rcl)
	recoil.emit(rcl_v)
	
	# Muzzle flash
	var flsh = muzzle_flash.instantiate() as GPUParticles3D
	muzzle.add_child(flsh)
	flsh.position = Vector3.ZERO
	flsh.rotation = Vector3.ZERO


func set_rpm(value: float):
	_rpm = value
	fire_timer.wait_time = 60.0 / _rpm


func press_trigger():
	is_trigger_pressed = true


func release_trigger():
	is_trigger_pressed = false
	is_trigger_reset = true


func _shoot_bullet():
	if not _chambered_bullet: return
	
	var rcl_amt = _chambered_bullet.shoot()
	_chambered_bullet = null
	
	## Apply recoil
	rcl_amt *= recoil_multiplier
	var rcl_v = Vector2(randf_range(sideways_recoil_min, sideways_recoil_max), rcl_amt)
	recoil.emit(rcl_v)
	
	# Muzzle flash
	if muzzle_flash:
		if fire_mode == FireMode.SINGLE or fire_mode == FireMode.SEMI:
			muzzle_flash.one_shot = true
		muzzle_flash.restart()


func unload_magazine() -> Magazine:
	var mag = magazine
	magazine = null
	return mag


func load_magazine(mag: Magazine):
	magazine = mag
	if not _chambered_bullet and magazine.get_bullet_count() > 0:
		_chamber_bullet()
