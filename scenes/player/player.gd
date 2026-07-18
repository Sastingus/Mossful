extends CharacterBody2D

const SPEED = 10000

var target_player_hp := 150.0

@onready var poison_timer: Timer = %PoisonTimer
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
	Globals.is_player_poi = true
	Globals.player_poi += Globals.on_hit_poi
	
	if poison_timer.is_stopped():
		poison_timer.start()
	print("poison is "+str(Globals.player_poi))

func poison_tick():
	if Globals.player_poi > 0:
		Globals.player_poi -= poison_timer.wait_time
		Globals.player_hp -= Globals.poi_dmg
	else:
		if Globals.player_hp != Globals.max_player_hp:
			Globals.player_hp += Globals.heal
