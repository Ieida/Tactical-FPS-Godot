class_name MainMenu extends Control


@export var main: PackedScene


var active_menu: Menu


func _ready():
	switch_to(main.instantiate())


func _on_back():
	switch_to(main.instantiate())


func switch_to(menu: Menu):
	if active_menu:
		await active_menu.close()
	add_child(menu)
	active_menu = menu
	active_menu.back.connect(_on_back)
	active_menu.go_to.connect(switch_to)
	active_menu.open()
