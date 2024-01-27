extends CharacterBody2D

# FRUIT STUFF

var life_points : int = 50

# MOVEMENT STUFF

const SPEED = 700.0
const JUMP_VELOCITY = -1200.0

var gravity = 3 * ProjectSettings.get_setting("physics/2d/default_gravity")

# BLOCKING STUFF

const MAX_BLOCKED_HITS = 5
const TIME_RECOVER_BLOCK = 2.0

var is_blocking : bool = false
var available_hit_blocks : int = MAX_BLOCKED_HITS
var recover_block_timer : float = 0.0

# ANIMATIONS

enum AnimState { IDLE, WALK }
var anim_state : AnimState = AnimState.IDLE

func _ready():
	pass
	
func _process(delta):
	
	if not is_blocking and available_hit_blocks < MAX_BLOCKED_HITS:
		recover_block_timer -= delta;
		if recover_block_timer <= 0.0:
			available_hit_blocks += 1
			recover_block_timer = TIME_RECOVER_BLOCK
			print("new block available! (", available_hit_blocks, ")")
	
func process_moves(buttons):
	
	var punch_button = buttons[0]
	var kick_button = buttons[1]
	var block_button = buttons[2]
	
	# BLOCK
	
	if Input.is_action_pressed(block_button) and available_hit_blocks > 0 and is_on_floor():
		is_blocking = true
		
	if Input.is_action_just_released(block_button) or available_hit_blocks == 0:
		is_blocking = false
		recover_block_timer = TIME_RECOVER_BLOCK
		
	# PUNCH
	
	if Input.is_action_pressed(punch_button):
		pass
		
	# KICK
	
	if Input.is_action_pressed(kick_button):
		pass

func process_movement(delta, jump_button, move_buttons):
	
	if is_blocking:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed(jump_button) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(move_buttons[0], move_buttons[1])
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func process_hit(body, damage):
	
	if not body.is_in_group("Fruit"):
		return
	
	if body.is_blocking:
		body.available_hit_blocks -= 1
		body.available_hit_blocks = max(body.available_hit_blocks, 0)
		print("enemy used block... (", body.available_hit_blocks, " remaining)")
	else:
		body.life_points -= damage
		life_points += damage
		
func update_animation(animated_sprite, idle_anim, walk_anim):
	
	if is_blocking:
		animated_sprite.play("block")
	elif abs(velocity.x) > 0.0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

	if velocity.x > 0.0:
		animated_sprite.flip_h = true
	elif velocity.x < 0.0:
		animated_sprite.flip_h = false
