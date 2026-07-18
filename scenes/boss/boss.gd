extends StaticBody2D

@export var patterns : Array[PackedScene]
@export var attackSpeed := 5.0

@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	attack_timer.wait_time = attackSpeed

func attack() -> void:
	var currentAttack = patterns.pick_random().instantiate()
	add_child(currentAttack)
	currentAttack.global_position = Vector2.ZERO
