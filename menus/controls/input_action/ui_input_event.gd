class_name UIInputEvent extends PanelContainer


var event: InputEvent
var stylebox: StyleBoxFlat
var highlight_timer: Timer


func _ready():
	$Name.text = event.as_text()
	stylebox = get_theme_stylebox("panel").duplicate()
	add_theme_stylebox_override("panel", stylebox)
	highlight_timer = Timer.new()
	highlight_timer.wait_time = 1
	highlight_timer.one_shot = true
	add_child(highlight_timer, false, Node.INTERNAL_MODE_FRONT)


func _input(evnt: InputEvent):
	if event.is_match(evnt) and evnt.is_pressed():
		highlight()


func highlight():
	await get_tree().process_frame
	if not is_zero_approx(highlight_timer.time_left):
		highlight_timer.start()
		return
	var s = stylebox
	var c = s.bg_color
	c.v = 0.75
	c.s = 1
	c.h = 0.5
	s.bg_color = c
	highlight_timer.start()
	await highlight_timer.timeout
	c.s = 0
	c.v = 0
	s.bg_color = c
