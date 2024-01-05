extends Node3D

@export var weapon: Weapon
@export var camera: PlayerCamera
@export var reload_time: float
@export var bullet: PackedScene
@export var animation_player: AnimationPlayer
@export var magazine: Magazine

func _ready():
	weapon.recoil.connect(_on_weapon_recoil)
	load_mag(magazine)
	rack_slide()

func _process(_delta):
	if Input.is_action_just_pressed("trigger"):
		press_trigger()
	elif Input.is_action_just_released("trigger"):
		release_trigger()
	if Input.is_action_just_pressed("reload"):
		reload()
	#if Input.is_action_just_pressed("rack_slide"):
	#	rack_slide()

func _on_weapon_recoil(vector: Vector2):
	camera.look_x(vector.y)
	camera.look_y(vector.x)
	animation_player.stop(true)
	animation_player.play("recoil")

#region Testing Purposes
func load_mag(mag: Magazine):
	var rnds_to_full = mag.max_rounds - mag.get_bullet_count()
	for r in rnds_to_full:
		var b = bullet.instantiate()
		mag.add_child.call_deferred(b)
		b.transform = Transform3D()
		mag.load_bullet(b)
#endregion

#region Weapon Functions
func press_trigger():
	if weapon is Gun:
		weapon.press_trigger()

func release_trigger():
	if weapon is Gun:
		weapon.release_trigger()

func reload():
	if weapon is Gun:
		release_trigger()
		set_process(false)
		var mag = weapon.unload_magazine()
		animation_player.play("reload")
		
		await get_tree().create_timer(reload_time).timeout
		
		load_mag(mag)
		weapon.load_magazine(mag)
		if not weapon._chambered_bullet: rack_slide()
		set_process(true)

func rack_slide():
	if weapon is Gun:
		weapon.rack_slide()
		animation_player.play("rack_slide")
#endregion
