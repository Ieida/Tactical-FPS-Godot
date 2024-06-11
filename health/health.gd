class_name Health extends Node


signal damaged
signal depleted
signal started_bleeding
signal stopped_bleeding


@export var max_amount: float = 100
@export var amount: float = 100


func _process(delta):
	if is_bleeding: _bleed_process(delta)


func _bleed_process(delta: float):
	_damage(bleed_rate * delta)


var is_bleeding = false
var bleed_rate: float = 0
func _bleed(rate: float):
	if is_equal_approx(rate, 0.0): return
	
	bleed_rate += rate
	if not is_bleeding:
		is_bleeding = true
		started_bleeding.emit()


var is_zero = false
func _damage(amt: float):
	if is_zero or is_equal_approx(amt, 0.0): return
	
	amount = clampf(amount - amt, 0, max_amount)
	damaged.emit()
	if amount <= 0:
		is_zero = true
		depleted.emit()


func damage(amt: float):
	if is_equal_approx(amt, 0.0): return
	
	_damage(amt)
	_bleed(amt)
