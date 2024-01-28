extends "res://assets/fruits/controller.gd"

func _process(delta):
	super._process(delta)

func _physics_process(delta):
	process_movement(delta, "JUMP_2", ["MOVE_LEFT_2", "MOVE_RIGHT_2"])

func _input(event):
	process_moves(["PUNCH_2", "KICK_2", "BLOCK_2", "MOVE_LEFT_2", "MOVE_RIGHT_2"])

func _on_punch_trigger_body_entered(body):
	process_hit(body, punch_damage)

func _on_kick_trigger_body_entered(body):
	process_hit(body, kick_damage)

func _on_animated_sprite_2d_animation_finished():
	if ($AnimatedSprite2D.animation == "punch") or \
		($AnimatedSprite2D.animation == "kick"):
		attack_charge = 0

func _emit_particles():
	$GPUParticles2D.restart()
