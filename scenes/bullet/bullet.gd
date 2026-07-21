extends Area2D
class_name Bullet

@export var speed: int = 225
@export var delay: float = 0.0
@export var spin: float = 0.0
@export var acceleration : int = 0

@onready var delay_timer: Timer = $DelayTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var warning_timer: Timer = $WarningTimer

var warning 

var bullet_spawned := false

var distance_traveled : float = 0
const DESPAWN_DISTANCE =  1500

func _ready() -> void:
	visible = false
	if delay != 0:
		delay_timer.wait_time = delay
		delay_timer.start()
	else:
		start_warning()

func _physics_process(delta: float) -> void:
	if bullet_spawned == true:
		var dir : Vector2 = Vector2.RIGHT.rotated(rotation)
		position += Vector2(dir.normalized() * speed * delta)
		distance_traveled += speed * delta
		rotation += spin/100
		speed += acceleration
		if distance_traveled > DESPAWN_DISTANCE:
			queue_free()

func spawn_bullet() -> void:
	warning.queue_free()
	particles.emitting = true
	bullet_spawned = true
	visible = true
	collision_shape_2d.disabled = false

func start_warning():
	warning_timer.start()
	warning = preload("uid://ffmlhhhju5p3").instantiate()
	add_sibling.call_deferred(warning)
	warning.global_position = self.position
	warning.scale = self.scale
	warning.rotation = self.rotation

func _on_body_entered(body: CollisionObject2D) -> void:
	if body is CharacterBody2D:
		SignalBus.player_poisoned.emit()
		queue_free()
