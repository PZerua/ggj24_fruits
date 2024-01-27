extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var isBackwardsAnim : bool = false

enum AnimState {
	IDLE,
	WALK
}

var enable_movement : bool = true

func _ready():
	pass
	
func _process(delta):
	pass
	
func _input(event):
	pass
	#if event.is_action_pressed("Interact"):
		#print("interact")
	#if event.is_action_pressed("Exit"):
		#get_tree().quit()

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
		
