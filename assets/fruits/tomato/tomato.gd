extends "res://assets/fruits/controller.gd"

var punch_pause_frame : int = 3
var kick_pause_frame : int = 1

func _init():
	fruit_type = FruitType.TOMATO

func _ready():
	look_right()
	
func _process(delta):
	process_moves(["PUNCH_1", "KICK_1", "BLOCK_1", "MOVE_LEFT_1", "MOVE_RIGHT_1"])
	super._process(delta)

func _physics_process(delta):
	process_movement(delta, "JUMP_1", ["MOVE_LEFT_1", "MOVE_RIGHT_1"])

func _on_punch_trigger_body_entered(body):
	process_hit(body, punch_damage)

func _on_kick_trigger_body_entered(body):
	process_hit(body, kick_damage, Vector2(0.5, -0.7).normalized())

func _on_animated_sprite_2d_animation_finished():
	if ($AnimatedSprite2D.animation == "punch") or \
	($AnimatedSprite2D.animation == "kick"):
		attack_charge = 0

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "punch" && \
		$AnimatedSprite2D.frame == punch_pause_frame && is_punching:
		$AnimatedSprite2D.pause()
		
	if $AnimatedSprite2D.animation == "kick" && \
		$AnimatedSprite2D.frame == kick_pause_frame && is_kicking:
		$AnimatedSprite2D.pause()

func _emit_particles():
	var direction = Vector2(1,0)
	if side == Sides.LEFT:
		direction.x = -1
	$GPUParticles2D.process_material.set("direction", direction)
	$GPUParticles2D.restart()
