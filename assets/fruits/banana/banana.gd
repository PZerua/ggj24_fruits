extends "res://assets/fruits/controller.gd"

var punch_pause_frame : int = 1
var kick_pause_frame : int = 0

func _init():
	fruit_type = FruitType.BANANA
	
func _ready():
	look_left()
	
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

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "punch":
		if $AnimatedSprite2D.frame == punch_pause_frame && is_punching:
			$AnimatedSprite2D.pause()
		if $AnimatedSprite2D.frame == 3:
			velocity = Vector2(0, 2000)
		
	if $AnimatedSprite2D.animation == "kick" && \
		$AnimatedSprite2D.frame == kick_pause_frame && is_kicking:
		$AnimatedSprite2D.pause()
		
func _emit_particles():
	var direction = Vector2(1,0)
	if side == Sides.LEFT:
		direction.x = -1
	$GPUParticles2D.process_material.set("direction", direction)
	$GPUParticles2D.restart()
