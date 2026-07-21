extends CharacterBody2D

const SPEED = 9000

var can_attack := true

@onready var poison_timer: Timer = %PoisonTimer
@onready var hp_label: Label = $HpLabel
@onready var heal_timer: Timer = %HealTimer
@onready var boss_bar: ProgressBar = $BossBar
@onready var attack_timer: Timer = %AttackTimer
@onready var attack_bar: ProgressBar = $AttackBar
@onready var hit_particles: GPUParticles2D = %HitParticles

func _ready() -> void:
	SignalBus.player_poisoned.connect(poisoned)
	boss_bar.max_value = Globals.boss_max_hp
	attack_timer.wait_time = Globals.player_atk_cooldown
	attack_bar.min_value = -attack_timer.wait_time


func _physics_process(delta: float) -> void:
	var inputDir := Vector2.ZERO
	
	inputDir = Input.get_vector("move_left","move_right","move_up","move_down")
	
	velocity = inputDir.normalized() * SPEED * delta
	move_and_slide()
	
	Globals.player_location = global_position

func _process(_delta: float) -> void:
	hp_label.text = "       hp:
	"+str(Globals.player_hp)+ "/"+str(Globals.max_player_hp)
	
	boss_bar.value = Globals.boss_hp
	attack_bar.value = -attack_timer.time_left
	
	if Globals.player_hp <= 0:
		die()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack_up"):
		attack("up")
	elif Input.is_action_just_pressed("attack_left"):
		attack("left")
	elif Input.is_action_just_pressed("attack_right"):
		attack("right")
	elif Input.is_action_just_pressed("attack_down"):
		attack("down")
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true

'
poison and health
'

func poisoned():
	Globals.is_player_poi = true
	Globals.player_poi += Globals.on_hit_poi
	hit_particles.restart()
	
	if poison_timer.is_stopped():
		poison_timer.start()


func poison_tick():
	if Globals.player_poi > 0:
		Globals.player_poi -= poison_timer.wait_time
		Globals.player_hp -= Globals.poi_dmg
	else:
		poison_timer.stop()
		heal_timer.start()

func heal_tick():
	if Globals.player_poi > 0:
		heal_timer.stop()
	else:
		if Globals.player_hp != Globals.max_player_hp:
				Globals.player_hp += Globals.heal

func die():
	queue_free() #TODO make death

'
attack
'

func attack(dir):
	if can_attack:
		match dir:
			"up":spawn_arrow(Vector2(0,-24),-90)
			"down":spawn_arrow(Vector2(0,24),90)
			"left":spawn_arrow(Vector2(-24,0),180)
			"right":spawn_arrow(Vector2(24,0),0)
		can_attack = false
		attack_timer.start()


func spawn_arrow(pos,dir):
	var new_arrow = preload("uid://2nrsaxpsfv4i").instantiate()
	add_sibling(new_arrow)
	new_arrow.position = pos+self.position
	new_arrow.rotation_degrees = dir


func _on_attack_timer_timeout() -> void:
	can_attack = true
