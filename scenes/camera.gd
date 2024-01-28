extends Camera2D

const MAX_DISTANCE_BETWEEN_CHARACTERS : float = 1036.0
const LERP_MOVE_SPEED : float = 0.5
const LERP_ZOOM_SPEED : float = 0.25

var tomato : CharacterBody2D
var banana : CharacterBody2D
var targets = [] # Array of targets to be tracked
var center_scene

@onready var screen_size = get_viewport_rect().size

@export var position_x_range = Vector2(-520, 520)
@export var move_speed = LERP_MOVE_SPEED # camera position lerp speed
@export var zoom_speed = LERP_ZOOM_SPEED  # camera zoom lerp speed
@export var min_zoom = 0.6  # camera won't zoom closer than this
@export var max_zoom = 1.1  # camera won't zoom farther than this

var shake_elapsed : float = 0.0
var shake_length : float = 0.0
var shake_amount : float = 0.0

func _ready():
	tomato = %Tomato
	banana = %Banana
	center_scene = position

func _process(delta):
	if !targets:
		return
	
	# Modify camera position
	var center_players = tomato.global_position.lerp(banana.global_position, 0.5)
	var baricentric_center = center_scene.lerp(center_players, 0.5)
	# Smoothing motion
	var new_pos = self.global_position.lerp(baricentric_center, delta * move_speed)
	position = Vector2(clamp(new_pos.x, position_x_range[0], position_x_range[1]), 0.0)
	# print(position)
	
	var dist = tomato.global_position.distance_to(banana.global_position)
	var f_dist = clamp(dist / MAX_DISTANCE_BETWEEN_CHARACTERS, 0.0, 1.0)
	
	# Update zoom
	var new_zoom = lerp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom), 1.0 - f_dist)
	zoom = zoom.lerp(new_zoom, delta * zoom_speed)
	
	# Update vertical offset to compensate the zoom and show only the upper part
	var new_offset = lerp(0, 200, 1.0 - f_dist)
	offset.y = lerp(offset.y, new_offset, delta * zoom_speed)
	
	# Add camera shake in case is active
	if shake_length > 0.0:
		var shakeX = randf_range(-1.0, 1.0) * shake_amount
		var shakeY = randf_range(-1.0, 1.0) * shake_amount

		position.x += shakeX;
		position.y += shakeY;

		shake_length -= delta
		
		if shake_length <= 0.0:
			move_speed = LERP_MOVE_SPEED

func add_target(t):
	if not t in targets:
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.erase(t)
		
func shake(amount, length):
	shake_amount = amount;
	shake_length = length;
	move_speed = 100;
