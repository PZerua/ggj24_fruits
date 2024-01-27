extends CharacterBody2D

# FRUIT STUFF

var life_points : int = 50
var punch_damage : int = 2
var kick_damage : int = 2

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
			
	# Invert UV of the sprite animateion
	update_animation()
	
	# Invert collider
	if velocity.x > 0.0:
		$Colliders.scale.x = 1
	elif velocity.x < 0.0:
		$Colliders.scale.x = -1
	
func process_moves(buttons):
	
	if is_knocked_out:
		return
	
	var punch_button = buttons[0]
	var kick_button = buttons[1]
	var block_button = buttons[2]
	
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
	
		
	if Input.is_action_just_pressed(punch_button):
		%PunchAnimation.play("Punch")
		
	# KICK
	
	if Input.is_action_just_pressed(kick_button):
		%KickAnimation.play("Kick")

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

	if velocity.x > 0.0:
		sprite.flip_h = true
		side = Sides.RIGHT
	elif velocity.x < 0.0:
		sprite.flip_h = false
		side = Sides.LEFT

func toggle_punch_enabled():
	$Colliders/PunchTrigger/PunchCollider.disabled = !$Colliders/PunchTrigger/PunchCollider.disabled

func toggle_kick_enabled():
	$Colliders/KickTrigger/KickCollider.disabled = !$Colliders/KickTrigger/KickCollider.disabled
