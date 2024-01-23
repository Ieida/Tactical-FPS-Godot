extends Node3D

@onready var camera: PlayerCamera = $CharacterBody3D/BodyMiddlePivot/PlayerCamera
@onready var body: CharacterBody3D = $CharacterBody3D
@onready var health: Health = $Components/Health
@onready var nausea: Nausea = $Components/Nausea
@onready var hitbox: Hitbox = $CharacterBody3D/Hitbox
@export var death_fade: Node

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	health.damaged.connect(_on_health_subtracted)
	health.depleted.connect(_on_health_reached_zero)
	health.started_bleeding.connect(_on_health_started_bleeding)
	
	body.add_collision_exception_with(hitbox)
	
	hitbox.hit_recieved.connect(_on_hitbox_hit_recieved)

func _process(_delta):
	pass

func _on_health_subtracted():
	var p = (health.amount / health.max_amount)
	death_fade.fade(1 - p)
	body.speed = body.max_speed * p

func _on_health_reached_zero():
	get_tree().quit()

func _on_health_started_bleeding():
	nausea.process_mode = Node.PROCESS_MODE_INHERIT

func _on_hitbox_hit_recieved(info: HitboxHitInfo):
	camera.shake(info.intensity, 2.0)
