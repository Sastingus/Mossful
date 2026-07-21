extends Bullet
class_name FollowingBullet

var following := false
@export var followUntilRange := 45.0
@export var notfollowtime := 0.2
@onready var stop_follow_range: Area2D = $StopFollowRange
@onready var not_follow_timer: Timer = $NotFollowTimer


func _physics_process(delta: float) -> void:
	if bullet_spawned == true:
		if following:
			look_at(Globals.player_location)
		var dir : Vector2 = Vector2.RIGHT.rotated(rotation)
		position += Vector2(dir.normalized() * speed * delta)
		distance_traveled += speed * delta
		
		speed += acceleration
		if distance_traveled > DESPAWN_DISTANCE:
			queue_free()

func spawn_bullet() -> void:
	warning.queue_free()
	particles.emitting = true
	bullet_spawned = true
	visible = true
	collision_shape_2d.disabled = false
	not_follow_timer.wait_time = notfollowtime
	not_follow_timer.start()
	$StopFollowRange/CollisionShape2D.shape.radius = followUntilRange

func stop_following() -> void:
	following = false

func start_following():
	following = true

func _on_body_entered(body: CollisionObject2D) -> void:
	if body is CharacterBody2D:
		SignalBus.player_poisoned.emit()
		queue_free()
