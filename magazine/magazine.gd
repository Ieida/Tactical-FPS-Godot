extends Node3D
class_name Magazine

@export var max_rounds: int
var _rounds: Array[Bullet]

func get_bullet_count() -> int:
	return _rounds.size()

func load_bullet(bullet: Bullet):
	if _rounds.size() < max_rounds:
		_rounds.append(bullet)
		if bullet.get_parent(): bullet.reparent(self)
		else: add_child(bullet)
		bullet.position = Vector3.ZERO
		bullet.rotation = Vector3.ZERO

func unload_bullet() -> Bullet:
	return _rounds.pop_back()
