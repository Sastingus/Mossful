extends CharacterBody2D

const SPEED = 100

func _physics_process(delta: float) -> void:
	var input_dir := Vector2.ZERO
	
	input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	
	velocity = input_dir.normalized() * SPEED
	move_and_slide()
