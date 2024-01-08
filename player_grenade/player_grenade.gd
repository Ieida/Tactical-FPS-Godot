extends PlayerWeapon

@export var grenade: Grenade
@export var player_body: Node
@export var throw_force: float = 5.0
@export var grenade_scene: PackedScene
@onready var placeholder_transform = grenade.transform

func _ready():
	grenade.add_collision_exception_with(player_body)

func _process(_delta):
	if Input.is_action_just_pressed("trigger"):
		throw()

func reload():
	is_reloading = true
	animation_player.play("reload")
	await animation_player.animation_finished
	grenade = grenade_scene.instantiate() as Grenade
	add_child(grenade)
	grenade.transform = placeholder_transform
	grenade.add_collision_exception_with(player_body)
	is_reloading = false

func throw():
	if is_trigger_pressed or is_reloading: return
	is_trigger_pressed = true
	
	animation_player.play("throw")
	await animation_player.animation_finished
	grenade.reparent(get_tree().root)
	grenade.throw(-global_basis.z * throw_force)
	grenade.release_spoon()
	grenade = null
	reload()
	is_trigger_pressed = false
