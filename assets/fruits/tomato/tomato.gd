extends "res://assets/fruits/controller.gd"

func _process(delta):
	
	if Input.is_action_just_pressed("PUNCH_1"):
		print("punch")

func _physics_process(delta):

	process_movement(delta, "JUMP_1", ["MOVE_LEFT_1", "MOVE_RIGHT_1"])

func _input(event):
	
	process_moves("BLOCK_1")
