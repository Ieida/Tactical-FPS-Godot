extends Control
class_name MissionBriefing

const _objective = preload("res://missions/briefing/objective.tscn")
@export var title: Label
@export var objectives_container: Container

func _ready():
	title.text = Mission._info.title
	for objective in Mission._info.objectives:
		var o = _objective.instantiate()
		o.objective = objective
		objectives_container.add_child(o)
