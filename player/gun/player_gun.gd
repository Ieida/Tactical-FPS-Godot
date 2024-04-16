extends PlayerWeapon

class_name PlayerGun

@export var gun: Gun
@export var magazine: Magazine
@export var bullet: PackedScene
@export var flashlight: Flashlight
@export var laser: Laser

func _ready():
	super._ready()
	gun.recoil.connect(_on_gun_recoil)
	load_mag(magazine)
	insert_magazine(magazine)
	gun.push_slide()
	
	## Turn off laser by default
	if laser and laser.is_on: laser.toggle_laser()
	
	## Turn off flashlight by default
	if flashlight and flashlight._is_on: flashlight.toggle_flashlight()

func _input(event):
	if is_holstered: return
	if event.is_action("trigger"):
		if event.is_pressed():
			press_trigger()
		elif event.is_released():
			release_trigger()

func _process(_delta):
	if not is_holstered:
		if flashlight and Input.is_action_just_pressed("flashlight_toggle"):
			toggle_flashlight()
		if Input.is_action_just_pressed("reload"):
			reload()
		if laser and Input.is_action_just_pressed("laser_toggle"):
			toggle_laser()

#region Gun Functions
func can_holster() -> bool:
	return not is_reloading

func toggle_flashlight():
	flashlight.toggle_flashlight()

func toggle_laser():
	laser.toggle_laser()

func press_trigger():
	gun.press_trigger()

func release_trigger():
	gun.release_trigger()

func remove_magazine():
	gun.unload_magazine()

func insert_magazine(new_magazine: Magazine):
	gun.load_magazine(new_magazine)

var is_reloading: bool = false
func reload():
	is_reloading = true
	animation_player.play("reload")
	if gun.magazine:
		await remove_magazine()
	
	load_mag(magazine) ## PLACEHOLDER
	
	await animation_player.animation_finished
	
	await insert_magazine(magazine)
	
	if gun.is_slide_lock_activated: await gun.deactivate_slide_lock()
	elif not gun._chambered_bullet: await gun.push_slide()
	
	is_reloading = false
	animation_player.queue("idle")

func rack_slide():
	animation_player.play("rack_slide")
	await gun.rack_slide()
	await animation_player.animation_finished

func _on_gun_recoil(vector: Vector2):
	if not is_reloading:
		animation_player.play("recoil")
	await get_tree().create_timer(0.01).timeout
	camera.recoil(vector, 0.01)
	animation_player.queue("idle")
#endregion

#region Testing Purposes
func load_mag(mag: Magazine):
	var rnds_to_full = mag.max_rounds - mag.get_bullet_count()
	for r in rnds_to_full:
		var b = bullet.instantiate()
		mag.load_bullet(b)
#endregion