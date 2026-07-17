extends Area2D

@export var speed: int = 225
@export var delay: float = 0.0

@onready var delay_timer: Timer = $DelayTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var bullet_spawned := false

func _ready() -> void:
	if delay != 0:
		delay_timer.wait_time = delay
		delay_timer.start()
	else:
		spawn_bullet()

func _physics_process(delta: float) -> void:
	if bullet_spawned == true:
		var dir : Vector2 = Vector2.RIGHT.rotated(rotation)
		position += Vector2(dir.normalized() * speed * delta)
	

func spawn_bullet() -> void:
	bullet_spawned = true
	visible = true
	collision_shape_2d.disabled = false
