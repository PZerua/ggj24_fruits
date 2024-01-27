extends "res://assets/fruits/controller.gd"

func _process(delta):
	
	super._process(delta)

	if Input.is_action_just_pressed("PUNCH_2"):
		%PunchAnimation.play("Punch")

func _physics_process(delta):
	process_movement(delta, "JUMP_2", ["MOVE_LEFT_2", "MOVE_RIGHT_2"])

func _input(event):
	process_moves(["PUNCH_2", "KICK_2", "BLOCK_2"])

func _on_punch_trigger_body_entered(body):
	process_hit(body, 10)
