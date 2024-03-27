extends Node

var info: MissionInfo

func abandon():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func load_mission(mission: MissionInfo):
	info = mission
	get_tree().change_scene_to_file("res://missions/briefing/mission_briefing.tscn")

func start():
	get_tree().change_scene_to_packed(info.mission_scene)
