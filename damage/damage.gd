extends Resource
class_name Damage

@export var amount: float

func apply_to(health: Health):
	health.damage(amount)
