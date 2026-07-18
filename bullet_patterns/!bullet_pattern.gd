extends Node2D

func _process(_delta: float) -> void:
	if !get_children().any(is_bullet):
		queue_free()

func is_bullet(node) -> bool:
	if node is Bullet:
		return true
	else:
		return false
