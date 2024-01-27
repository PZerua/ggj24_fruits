extends "res://assets/fruits/controller.gd"

func _process(delta):
	super._process(delta)

func _physics_process(delta):
	process_movement(delta, "JUMP_1", ["MOVE_LEFT_1", "MOVE_RIGHT_1"])

func _input(event):
	process_moves(["PUNCH_1", "KICK_1", "BLOCK_1"])

func _on_punch_trigger_body_entered(body):
	process_hit(body, punch_damage)

func _on_kick_trigger_body_entered(body):
	process_hit(body, kick_damage)
