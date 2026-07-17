extends CharacterBody2D

const SPEED = 10000

func _physics_process(delta: float) -> void:
	var inputDir := Vector2.ZERO
	
	inputDir = Input.get_vector("move_left","move_right","move_up","move_down")
	
	velocity = inputDir.normalized() * SPEED * delta
	move_and_slide()
