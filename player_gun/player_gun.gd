extends PlayerWeapon

class_name PlayerGun

@export var gun: Gun
@export var magazine: Magazine
@export var bullet: PackedScene

func _ready():
	super._ready()
	gun.recoil.connect(_on_gun_recoil)
	load_mag(magazine)
	rack_slide()

func _process(_delta):
	if not is_holstered:
		if Input.is_action_just_pressed("trigger"):
			press_trigger()
		elif Input.is_action_just_released("trigger"):
			release_trigger()
		if Input.is_action_just_pressed("reload"):
			reload()

#region Gun Functions
func can_holster() -> bool:
	return not is_trigger_pressed and not is_reloading

var is_trigger_pressed = false
func press_trigger():
	if not is_reloading:
		is_trigger_pressed = true
		gun.press_trigger()

func release_trigger():
	is_trigger_pressed = false
	gun.release_trigger()

var is_reloading = false
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
	camera.look_x(vector.y)
	camera.look_y(vector.x)
	animation_player.stop(true)
	animation_player.clear_queue()
	animation_player.play("recoil")
	animation_player.queue("idle")
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