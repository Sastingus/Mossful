extends StaticBody2D
class_name BossEntity

@export var patterns : Array[PackedScene]
var previous_patterns := []
@export var attackSpeed := 5.0
var attackSpeedRand := 0.5


@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	attack_timer.wait_time = attackSpeed+ randf_range(-attackSpeedRand,attackSpeedRand)
	SignalBus.boss_hit.connect(take_damage)

func attack() -> void:
	var attackPicked := false
	while not attackPicked:
		var possibleAttack = patterns.pick_random()
		if not previous_patterns.has(possibleAttack):
			previous_patterns.append(possibleAttack)
			var currentAttack = possibleAttack.instantiate()
			add_child(currentAttack)
			currentAttack.global_position = Vector2.ZERO
			attack_timer.wait_time = attackSpeed + randf_range(-attackSpeedRand,attackSpeedRand)
			if previous_patterns.size() >= patterns.size():
				previous_patterns.clear()
			attackPicked = true


func take_damage():
	Globals.boss_hp -= Globals.player_dmg
	if Globals.boss_hp <= 0:
		die()

func die():
	queue_free()
	print("boss killed!")
