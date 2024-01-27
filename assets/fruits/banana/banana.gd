extends "res://assets/fruits/controller.gd"

func _physics_process(delta):

	process_movement(delta, "JUMP_2", ["MOVE_LEFT_2", "MOVE_RIGHT_2"])
