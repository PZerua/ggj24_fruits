extends CharacterBody2D

# FRUIT STUFF

var life_points : int = 50
var punch_damage : int = 2
var kick_damage : int = 2

var attack_charge : float = 0.0
var attack_max_charge : float = 1.5

# MOVEMENT STUFF

const SPEED = 700.0
const JUMP_VELOCITY = -1300.0

enum Sides { LEFT, RIGHT }
var side = Sides.RIGHT
var gravity = 3 * ProjectSettings.get_setting("physics/2d/default_gravity")

# BLOCKING STUFF

const MAX_BLOCKED_HITS = 5
const TIME_RECOVER_BLOCK = 2.0
const TIME_RECOVER_KNOCKOUT = 1.0

var is_blocking : bool = false
var is_punching : bool = false
var is_kicking : bool = false
var is_knocked_out : bool = false

var available_hit_blocks : int = MAX_BLOCKED_HITS
var recover_block_timer : float = 0.0
var recover_knockout_timer : float = TIME_RECOVER_KNOCKOUT
var last_block_time : float = 0.0

func _ready():
	pass
	
func _process(delta):
	
	if is_knocked_out:
		recover_knockout_timer -= delta;
		if recover_knockout_timer <= 0.0:
			is_knocked_out = false
	
	if not is_blocking and available_hit_blocks < MAX_BLOCKED_HITS:
		recover_block_timer -= delta;
		if recover_block_timer <= 0.0:
			available_hit_blocks += 1
			recover_block_timer = TIME_RECOVER_BLOCK
			print("new block available! (", available_hit_blocks, ")")
			
	
	if (is_punching or is_kicking):
		attack_charge += delta
		# update shaking
		var shake_intensity = clamp(attack_charge/attack_max_charge, 0.0, 1.0)
		get_node("../MultiTargetCamera").shake(shake_intensity * 50, 1e10)
		
	if (attack_charge >= attack_max_charge):
		release_attack()
		
	# Invert UV of the sprite animateion
	if (attack_charge == 0):
		update_animation()
	
func release_attack():
	var sprite = $AnimatedSprite2D
	
	if (is_punching):
		%PunchAnimation.play("Punch")
		sprite.play("punch")
		is_punching = false
		var impulse = Vector2(10000, -1000)
		impulse = %Colliders.global_transform.basis_xform(impulse) * attack_charge
		velocity += impulse

	if (is_kicking):
		%KickAnimation.play("Kick")
		sprite.play("kick")
		is_kicking = false
		
	get_node("../MultiTargetCamera").stop_shake()

func check_direction(left_button, right_button):
	if Input.is_action_pressed(left_button):
		look_left()
	
	if Input.is_action_pressed(right_button):
		look_right()
	
func process_moves(buttons):
	
	if is_knocked_out:
		return
	
	var punch_button = buttons[0]
	var kick_button = buttons[1]
	var block_button = buttons[2]
	var left_button = buttons[3]
	var right_button = buttons[4]
	
	if Input.is_action_just_pressed(left_button):
		look_left()
	
	if Input.is_action_just_pressed(right_button):
		look_right()
		
	if (Input.is_action_just_released(right_button) or Input.is_action_just_released(left_button)):
		check_direction(left_button, right_button)
	
	# BLOCK
	
	if Input.is_action_just_pressed(block_button) and available_hit_blocks > 0 and is_on_floor():
		is_blocking = true
		# Get first frame to check parry later
		if Input.is_action_just_pressed(block_button):
			last_block_time = Time.get_ticks_msec()
		
	if Input.is_action_just_released(block_button) or available_hit_blocks == 0:
		is_blocking = false
		recover_block_timer = TIME_RECOVER_BLOCK
		
	# PUNCH
	
	var sprite = $AnimatedSprite2D
	
	if Input.is_action_just_pressed(punch_button) && attack_charge == 0:
		is_punching = true
		sprite.play("punch")
	
	# KICK
	
	if Input.is_action_just_pressed(kick_button) && attack_charge == 0:
		is_kicking = true
		sprite.play("kick")
		
	if (Input.is_action_just_released(punch_button) or
		Input.is_action_just_released(kick_button)) && attack_charge >= 0:
		release_attack()
		
func process_movement(delta, jump_button, move_buttons):
	
	if is_blocking or is_knocked_out:
		return

	var final_speed = SPEED
	
	# Add the gravity.
	if not is_on_floor():
		final_speed *= 1.5
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed(jump_button) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(move_buttons[0], move_buttons[1])
	if direction:
		velocity.x = direction * final_speed
	else:
		velocity.x = move_toward(velocity.x, 0, final_speed)

	move_and_slide()

func process_hit(body, damage):
	
	# BODY: THE FRUIT THAT RECEIVES THE DAMAGE
	
	if not body.is_in_group("Fruit"):
		return
	
	var can_block = body.is_blocking and side != body.side
	
	if can_block:
		# Parry??
		var dt = Time.get_ticks_msec() - body.last_block_time
		if dt < 350:
			print("PARRY!!")
			is_knocked_out = true
			recover_knockout_timer = TIME_RECOVER_KNOCKOUT
		else:
			body.available_hit_blocks -= 1
			body.available_hit_blocks = max(body.available_hit_blocks, 0)
			print("ENEMY BLOCKED (", body.available_hit_blocks, " remaining)")
	else:
		body.life_points -= damage
		life_points += damage
		emit_particles(body)
		
func look_right():
	var sprite = $AnimatedSprite2D
	sprite.flip_h = false
	side = Sides.RIGHT
	$Colliders.scale.x = 1
		
func look_left():
	var sprite = $AnimatedSprite2D
	sprite.flip_h = true
	side = Sides.LEFT
	$Colliders.scale.x = -1

func update_animation():
	
	var sprite = $AnimatedSprite2D
	
	if is_knocked_out:
		pass
		#sprite.play("knock")
	elif is_blocking:
		sprite.play("block")
	elif abs(velocity.x) > 0.0:
		sprite.play("walk")
	else:
		sprite.play("idle")


func toggle_punch_enabled():
	$Colliders/PunchTrigger/PunchCollider.disabled = !$Colliders/PunchTrigger/PunchCollider.disabled

func toggle_kick_enabled():
	$Colliders/KickTrigger/KickCollider.disabled = !$Colliders/KickTrigger/KickCollider.disabled

func emit_particles(fruit):
	pass
