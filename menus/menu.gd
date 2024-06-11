class_name Menu extends Control


signal back
signal go_to


func _init():
	scale = Vector2(0.8, 0.8)
	modulate = Color.TRANSPARENT


func close():
	mouse_filter = Control.MOUSE_FILTER_STOP
	var t = create_tween().set_parallel(true)
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	await t.finished
	queue_free()


func open():
	var t = create_tween().set_parallel(true)
	t.tween_property(self, "scale", Vector2.ONE, 0.5).from(Vector2(0.8, 0.8))
	t.tween_property(self, "modulate", Color.WHITE, 0.5).from(Color.TRANSPARENT)
