extends PlayerWeapon

class_name PlayerGun

@export var gun: Gun
@export var magazine: Magazine
@export var bullet: PackedScene
@export var flashlight: Flashlight

func _ready():
	super._ready()
	gun.recoil.connect(_on_gun_recoil)
	load_mag(magazine)
	rack_slide()

func _process(_delta):
	if not is_holstered:
		if flashlight and Input.is_action_just_pressed("flashlight_toggle"):
			toggle_flashlight()
		if Input.is_action_just_pressed("trigger"):
			press_trigger()
		elif Input.is_action_just_released("trigger"):
			release_trigger()
		if Input.is_action_just_pressed("reload"):
			reload()

#region Gun Functions
func can_holster() -> bool:
	return not is_trigger_pressed and not is_reloading

func toggle_flashlight():
	flashlight.toggle_flashlight()

var is_trigger_pressed: bool = false
func press_trigger():
	if not is_reloading:
		is_trigger_pressed = true
		gun.press_trigger()

func release_trigger():
	is_trigger_pressed = false
	gun.release_trigger()

var is_reloading: bool = false
func reload():
	if gun.magazine and not is_trigger_pressed:
		is_reloading = true
		var mag = gun.unload_magazine()
		if gun._chambered_bullet:
			animation_player.play("reload")
		else:
			animation_player.play("reload_empty")
		animation_player.queue("idle")
		
		await animation_player.animation_finished
		
		load_mag(mag)
		gun.load_magazine(mag)
		if not gun._chambered_bullet: rack_slide()
		is_reloading = false

func rack_slide():
	gun.rack_slide()

func _on_gun_recoil(vector: Vector2):
	animation_player.play("recoil")
	animation_player.queue("idle")
	while animation_player.current_animation != "recoil":
		await animation_player.animation_changed
	camera.recoil(vector, 0.01)
#endregion

#region Testing Purposes
func load_mag(mag: Magazine):
	var rnds_to_full = mag.max_rounds - mag.get_bullet_count()
	for r in rnds_to_full:
		var b = bullet.instantiate()
		mag.add_child.call_deferred(b)
		b.transform = Transform3D()
		mag.load_bullet(b)
#endregion
