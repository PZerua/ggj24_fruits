extends "res://assets/fruits/controller.gd"

const IDLE_TIME_TO_CRY : float = 5000.0 # ms
const CRY_TIME : float = 1.5 # seconds

var punch_pause_frame : int = 3
var kick_pause_frame : int = 1

var is_crying : bool = false
var last_input_time : float = 0.0
var cry_timer : float = 0.0

func _init():
	fruit_type = FruitType.TOMATO

func _ready():
	look_right()
	
func _process(delta):
	
	var new_time = Time.get_ticks_msec()
	if (new_time - last_input_time) > IDLE_TIME_TO_CRY:
		is_crying = true
	
	if is_crying:
		$AnimatedSprite2D.play("cry")
		cry_timer += delta
		if cry_timer >= CRY_TIME:
			last_input_time = new_time
			cry_timer = 0.0
			is_crying = false
	else:
		process_moves(["PUNCH_1", "KICK_1", "BLOCK_1", "MOVE_LEFT_1", "MOVE_RIGHT_1"])
		super._process(delta)

func _physics_process(delta):
	process_movement(delta, "JUMP_1", ["MOVE_LEFT_1", "MOVE_RIGHT_1"])

# Any event causes to stop crying...
func _input(event):
	is_crying = false
	last_input_time = Time.get_ticks_msec()

func _on_punch_trigger_body_entered(body):
	process_hit(body, punch_damage)

func _on_kick_trigger_body_entered(body):
	process_hit(body, kick_damage, Vector2(0.5, -0.7).normalized())

func _on_animated_sprite_2d_animation_finished():
	if ($AnimatedSprite2D.animation == "punch") or \
	($AnimatedSprite2D.animation == "kick"):
		attack_charge = 0
		attack_cooldown = attack_max_cooldown
		$AttackAudioStream.stream = load("res://assets/audio/tomato_hit.ogg")
		$AttackAudioStream.play()
		
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
