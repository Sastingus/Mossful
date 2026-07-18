extends CharacterBody2D

const SPEED = 10000

var target_player_hp := 150.0

@onready var poison_timer: Timer = %PoisonTimer
@onready var hp_label: Label = $HpLabel
@onready var heal_timer: Timer = %HealTimer

func _ready() -> void:
	SignalBus.player_poisoned.connect(poisoned)
	

func _physics_process(delta: float) -> void:
	var inputDir := Vector2.ZERO
	
	inputDir = Input.get_vector("move_left","move_right","move_up","move_down")
	
	velocity = inputDir.normalized() * SPEED * delta
	move_and_slide()

func _process(_delta: float) -> void:
	hp_label.text = "       hp:
	"+str(Globals.player_hp)+ "/150.0"
	
	if Globals.player_hp <= 0:
		die()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()


'
poison and health
'

func poisoned():
	Globals.is_player_poi = true
	Globals.player_poi += Globals.on_hit_poi
	
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

func attack():
	pass
	
