extends "res://assets/fruits/controller.gd"

func _process(delta):
	pass	
	#var mat : StandardMaterial3D = %Sprite2D.get_surface_override_material(0)
	#flip_uv_if_necessary(mat, "", "")

func _physics_process(delta):

	process_movement(delta, "JUMP_1", ["MOVE_LEFT_1", "MOVE_RIGHT_1"])

func _input(event):
	
	process_moves(["PUNCH_1", "KICK_1", "BLOCK_1"])

func make_laugh(player, intensity):
	if player == "TOMATO":
		funny += intensity
		%Banana.funny -= intensity;

