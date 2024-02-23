extends Node3D

@onready var camera: PlayerCamera = $CharacterBody3D/BodyMiddlePivot/PlayerCamera
@onready var body: CharacterBody3D = $CharacterBody3D
@onready var health: Health = $Components/Health
@onready var nausea: Nausea = $Components/Nausea
@export var death_fade: Node
var death_scene_path: String = "res://death_screen/death_screen.tscn"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	health.damaged.connect(_on_health_subtracted)
	health.depleted.connect(_on_health_reached_zero)
	health.started_bleeding.connect(_on_health_started_bleeding)

func _process(_delta):
	pass

func _on_health_subtracted():
	var p = (health.amount / health.max_amount)
	death_fade.fade(1 - p)
	body.speed = body.max_speed * p

func _on_health_reached_zero():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	(func cs(): get_tree().change_scene_to_file(death_scene_path)).call_deferred()

func _on_health_started_bleeding():
	nausea.process_mode = Node.PROCESS_MODE_INHERIT
