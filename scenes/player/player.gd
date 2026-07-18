extends CharacterBody2D

const SPEED = 10000

var target_player_hp := 150.0

@onready var poison_timer: Timer = %PoisonTimer
@onready var poison_tick_timer: Timer = %PoisonTickTimer
@onready var hp_label: Label = $HpLabel

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

func poisoned():
	Globals.player_poi = true
	poison_timer.wait_time += Globals.on_hit_poi
	if poison_timer.is_stopped():
		poison_timer.start()
	if poison_tick_timer.is_stopped():
		poison_tick_timer.start()

func poison_tick():
	if Globals.player_poi:
		Globals.player_hp -= Globals.poi_dmg
	else:
		poison_tick_timer.stop()

func poison_end() -> void:
	Globals.player_poi = false
	
