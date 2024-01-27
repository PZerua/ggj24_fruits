extends Camera2D

var tomato
var banana
var targets = [] # Array of targets to be tracked
var center_scene
const zoom_range = Vector2(0.5, 0.7)

@export var position_x_range = Vector2(-520, 520)
@export var move_speed = 2 # camera position lerp speed
@export var zoom_speed = 2.0  # camera zoom lerp speed
@export var min_zoom = 0.1  # camera won't zoom closer than this
@export var max_zoom = 1.5  # camera won't zoom farther than this
@export var margin = Vector2(200, 400)  # include some buffer area around targets
@onready var screen_size = get_viewport_rect().size

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
	position = Vector2(clamp(new_pos.x, position_x_range[0], position_x_range[1]), new_pos.y)
	print(position)

func add_target(t):
	if not t in targets:
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.erase(t)
