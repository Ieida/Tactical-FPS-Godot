extends Node

enum WindowMode {FULLSCREEN = 3, EXCLUSIVE = 4}
enum VSyncMode {DISABLED = 0, ENABLED = 1, ADAPTIVE = 2, MAILBOX = 3}

@export var settings: Dictionary
var res: Resource

func _enter_tree():
	load_from_disk()
	
	## Apply settings
	DisplayServer.window_set_vsync_mode(settings[&"vsync"])
	DisplayServer.window_set_mode(settings[&"window_mode"])

func get_setting(setting: StringName) -> Variant:
	return res.get_meta(setting)

func set_setting(setting: StringName, value: Variant):
	res.set_meta(setting, value)
	save()

func save():
	ResourceSaver.save(res, "user://settings.tres")

func load_from_disk():
	## Make sure the settings file exists
	if not FileAccess.file_exists("user://settings.tres"):
		ResourceSaver.save(Resource.new(), "user://settings.tres")
	
	## Load the settings file
	res = ResourceLoader.load("user://settings.tres")
	
	## Make sure there are no missing settings
	for setting in settings:
		if not res.has_meta(setting):
			res.set_meta(setting, settings[setting])
	save()
