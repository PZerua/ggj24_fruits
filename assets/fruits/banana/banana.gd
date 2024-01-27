extends "res://assets/fruits/controller.gd"

func _process(delta):
	update_animation($AnimatedSprite2D, "", "")

func _physics_process(delta):
	process_movement(delta, "JUMP_2", ["MOVE_LEFT_2", "MOVE_RIGHT_2"])

func _input(event):
	process_moves(["PUNCH_2", "KICK_2", "BLOCK_2"])
