extends Node

var res: Resource

func _ready():
	load_from_disk()
	DisplayServer.window_set_mode(get_setting("window_mode"))

func get_setting(setting: StringName) -> Variant:
	return res.get_meta(setting)

func set_setting(setting: StringName, value: Variant):
	res.set_meta(setting, value)
	save()

func save():
	ResourceSaver.save(res, "user://settings.tres")

func load_from_disk():
	res = ResourceLoader.load("user://settings.tres")
