class_name MissionBriefing extends Menu


const _objective = preload("res://missions/briefing/objective.tscn")


@export var title: Label
@export var objectives_container: Container
@export var start: GameMenuButton
@export var back: GameMenuButton


var current_info: MissionInfo


func _ready():
	start.pressed.connect(_on_start)
	back.pressed.connect(_on_back)


func _on_back():
	close()


func _on_start():
	get_tree().change_scene_to_packed(current_info.scene)


func set_info(info: MissionInfo):
	# Clear previous objectives
	if current_info:
		for c in objectives_container.get_children():
			c.queue_free()
	
	# Load new ones
	current_info = info
	title.text = info.title
	for objective in info.objectives:
		var o = _objective.instantiate()
		o.objective = objective
		objectives_container.add_child(o)
