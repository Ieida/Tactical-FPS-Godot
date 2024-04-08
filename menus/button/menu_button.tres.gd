extends Button

class_name GameMenuButton

@export var duration: float = 0.1
@export var color: Color = Color.GHOST_WHITE
@export var skew: Vector2 = Vector2(0.5, 0)
@export var content_margins: Vector4 = Vector4(45, 15, 45, 15)
@export var border_width: Vector4 = Vector4(0, 0, 0, 0)
@export var is_focused: bool = false
var tween: Tween
var default_stylebox: StyleBoxFlat

func _ready():
	pressed.connect(_contract)
	pressed.connect(_on_pressed)
	focus_entered.connect(_expand)
	focus_exited.connect(_contract)
	default_stylebox = get_theme_stylebox("normal")
	var sb = default_stylebox.duplicate()
	add_theme_stylebox_override("normal", sb)
	add_theme_stylebox_override("hover", sb)
	add_theme_stylebox_override("pressed", sb)
	add_theme_stylebox_override("disabled", sb)
	add_theme_stylebox_override("focus", sb)
	if is_focused:
		grab_focus.call_deferred()

var was_hovered = false
func _process(_delta):
	if not was_hovered and is_hovered():
		_expand()
	elif was_hovered and not is_hovered() and not has_focus():
		_contract()
	was_hovered = is_hovered()

func _contract():
	tween = create_tween().set_parallel(true)
	var sb = get_theme_stylebox("normal")
	tween.tween_property(sb, "bg_color", default_stylebox.bg_color, duration)
	tween.tween_property(sb, "border_color", default_stylebox.border_color, duration)
	tween.tween_property(sb, "skew", default_stylebox.skew, duration)
	tween.tween_property(sb, "border_width_left", default_stylebox.border_width_left, duration)
	tween.tween_property(sb, "border_width_top", default_stylebox.border_width_top, duration)
	tween.tween_property(sb, "border_width_right", default_stylebox.border_width_right, duration)
	tween.tween_property(sb, "border_width_bottom", default_stylebox.border_width_bottom, duration)
	tween.tween_property(sb, "content_margin_left", default_stylebox.content_margin_left, duration)
	tween.tween_property(sb, "content_margin_top", default_stylebox.content_margin_top, duration)
	tween.tween_property(sb, "content_margin_right", default_stylebox.content_margin_right, duration)
	tween.tween_property(sb, "content_margin_bottom", default_stylebox.content_margin_bottom, duration)

func _expand():
	tween = create_tween().set_parallel(true)
	var sb = get_theme_stylebox("normal")
	tween.tween_property(sb, "bg_color", color, duration)
	var bc = color
	bc.a = 0
	tween.tween_property(sb, "border_color", bc, duration)
	tween.tween_property(sb, "skew", skew, duration)
	tween.tween_property(sb, "border_width_left", border_width.x, duration)
	tween.tween_property(sb, "border_width_top", border_width.y, duration)
	tween.tween_property(sb, "border_width_right", border_width.z, duration)
	tween.tween_property(sb, "border_width_bottom", border_width.w, duration)
	tween.tween_property(sb, "content_margin_left", content_margins.x, duration)
	tween.tween_property(sb, "content_margin_top", content_margins.y, duration)
	tween.tween_property(sb, "content_margin_right", content_margins.z, duration)
	tween.tween_property(sb, "content_margin_bottom", content_margins.w, duration)

func _on_pressed():
	pass
