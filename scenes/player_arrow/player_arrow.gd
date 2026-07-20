extends Area2D

const SPEED = 350
const DESPAWN_DISTANCE = 1200

var distance_traveled := 0

func _physics_process(delta: float) -> void:
	var dir : Vector2 = Vector2.RIGHT.rotated(rotation)
	position += Vector2(dir * SPEED * delta)
	distance_traveled += SPEED * delta
	if distance_traveled > DESPAWN_DISTANCE:
		queue_free()

func _on_body_entered(body: CollisionObject2D) -> void:
	if body is BossEntity:
		SignalBus.boss_hit.emit()
		queue_free()
