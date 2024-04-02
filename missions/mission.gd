extends Node

var _info: MissionInfo

func select(info: MissionInfo):
	_info = info
	get_tree().change_scene_to_file("res://missions/briefing/mission_briefing.tscn")

func start():
	get_tree().change_scene_to_packed(_info.scene)
