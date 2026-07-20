extends StaticBody2D
class_name BossEntity

@export var patterns : Array[PackedScene]
@export var attackSpeed := 5.0
var attackSpeedRand := 0.5

@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	attack_timer.wait_time = attackSpeed+ randf_range(-attackSpeedRand,attackSpeedRand)
	SignalBus.boss_hit.connect(take_damage)

func attack() -> void:
	var currentAttack = patterns.pick_random().instantiate()
	add_child(currentAttack)
	currentAttack.global_position = Vector2.ZERO
	attack_timer.wait_time = attackSpeed + randf_range(-attackSpeedRand,attackSpeedRand)

func take_damage():
	Globals.boss_hp -= Globals.player_dmg
	if Globals.boss_hp <= 0:
		die()

func die():
	print("boss killed!")
