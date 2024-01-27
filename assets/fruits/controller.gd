extends CharacterBody2D

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

enum AnimState {
	IDLE,
	WALK
}

var enable_movement : bool = true

func _ready():
	pass
	
func _process(delta):
	if not is_blocking and available_hit_blocks < MAX_BLOCKED_HITS:
		recover_block_timer -= delta;
		if recover_block_timer <= 0.0:
			available_hit_blocks += 1
			recover_block_timer = TIME_RECOVER_BLOCK
			print("new block available! (", available_hit_blocks, ")")
			
func process_moves(block_button):
	
	# BLOCK
	
	if Input.is_action_pressed(block_button):
		is_blocking = true
		
	if Input.is_action_just_released(block_button):
		is_blocking = false
		recover_block_timer = TIME_RECOVER_BLOCK
		
	# THIS SIMULATED THE 'ON HIT' METHOD
	if Input.is_action_just_pressed("JUMP_2"):
		process_hit()

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

	#var mat : StandardMaterial3D = %Sprite/Plane.get_surface_override_material(0)
	#if (abs(velocity.z) + abs(velocity.x)) / 2.0 > 0.00:
		#mat.albedo_texture = walking_anim
		#mat.emission_texture = walking_anim_emissive
		#anim_state = AnimState.WALK
	#else:
		#mat.albedo_texture = standing_anim
		#mat.emission_texture = standing_anim_emissive
		#anim_state = AnimState.IDLE

	#if velocity.x > 0.0:
		#mat.uv1_scale.x = -1
	#elif velocity.x < 0.0:
		#mat.uv1_scale.x = 1
		

func process_hit():
	if is_blocking:
		available_hit_blocks -= 1
		available_hit_blocks = max(available_hit_blocks, 0)
		print("block used... (", available_hit_blocks, ")")
