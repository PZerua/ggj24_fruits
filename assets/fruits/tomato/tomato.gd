extends "res://assets/fruits/controller.gd"

func _process(delta):

	if Input.is_action_just_pressed("PUNCH_1"):
		%PunchAnimation.play("Punch")
	
	update_animation($AnimatedSprite2D, "", "")

func _physics_process(delta):

	process_movement(delta, "JUMP_1", ["MOVE_LEFT_1", "MOVE_RIGHT_1"])

func _input(event):
	
	process_moves(["PUNCH_1", "KICK_1", "BLOCK_1"])
	
	
func apply_hit(body, damage):
	if body.is_in_group("Fruit"):
		body.process_hit(damage)
		
	life_points += damage

func _on_punch_trigger_body_entered(body):
	apply_hit(body, 10)

