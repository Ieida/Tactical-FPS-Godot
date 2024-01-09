extends Button

class_name GameMenuButton

@export var stylebox: StyleBoxFlat
@export var duration: float = 1.0
@export var skew: float = 0.5
@export var expand: float = 40.0
var tween: Tween

func _ready():
	pressed.connect(_contract)
	focus_entered.connect(_expand)
	focus_exited.connect(_contract)

var was_hovered = false
func _process(_delta):
	if not was_hovered and is_hovered():
		_expand()
	elif was_hovered and not is_hovered():
		_contract()
	was_hovered = is_hovered()

func _contract():
	tween = create_tween().set_parallel(true)
	tween.tween_property(stylebox, "skew:x", 0.0, duration).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(stylebox, "expand_margin_left", 0.0, duration).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(stylebox, "expand_margin_right", 0.0, duration).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished

func _expand():
	tween = create_tween().set_parallel(true)
	tween.tween_property(stylebox, "skew:x", skew, duration).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(stylebox, "expand_margin_left", expand, duration).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(stylebox, "expand_margin_right", expand, duration).set_trans(Tween.TRANS_ELASTIC)
