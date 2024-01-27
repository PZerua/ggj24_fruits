extends CharacterBody2D

# CHARACTER MOVEMENT STUFF

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var enable_movement : bool = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
	
	if Input.is_action_pressed(block_button):
		is_blocking = true
		
	if Input.is_action_just_released(block_button):
		is_blocking = false
		recover_block_timer = TIME_RECOVER_BLOCK
		
	# THIS SIMULATED THE 'ON HIT' METHOD
	if Input.is_action_just_pressed("JUMP_2"):
		process_hit()
		
	# PUNCH
	
	if Input.is_action_pressed(punch_button):
		pass
		
	# KICK
	
	if Input.is_action_pressed(kick_button):
		pass

func process_movement(delta, jump_button, move_buttons):
	
	if not enable_movement:
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

func process_hit():
	
	if is_blocking:
		available_hit_blocks -= 1
		available_hit_blocks = max(available_hit_blocks, 0)
		print("block used... (", available_hit_blocks, ")")
		
func flip_uv_if_necessary(mat : StandardMaterial3D, idle_anim, walk_anim):
	
	if abs(velocity.x) > 0.0:
		mat.albedo_texture = walk_anim
		anim_state = AnimState.WALK
	else:
		mat.albedo_texture = idle_anim
		anim_state = AnimState.IDLE

	if velocity.x > 0.0:
		mat.uv1_scale.x = -1
	elif velocity.x < 0.0:
		mat.uv1_scale.x = 1
	
