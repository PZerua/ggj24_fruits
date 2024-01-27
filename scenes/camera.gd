extends Camera2D

var tomato
var banana
const center_scene = Vector2(0, 0)
const FOLLOW_SPEED = 2
const zoom_range = Vector2(0.5, 0.7)
const position_x_range = Vector2(100, 1000)

@export var move_speed = 4 # camera position lerp speed
@export var zoom_speed = 2.0  # camera zoom lerp speed
@export var min_zoom = 0.1  # camera won't zoom closer than this
@export var max_zoom = 1.5  # camera won't zoom farther than this
@export var margin = Vector2(200, 400)  # include some buffer area around targets

var targets = [] # Array of targets to be tracked

@onready var screen_size = get_viewport_rect().size

func _ready():
	self.global_position = center_scene
	tomato = %Tomato
	banana = %Banana

func _process(delta):
	if !targets:
		return
	
	#if Input.is_action_just_pressed("PUNCH_1"):
		#self.global_position += Vector2(0,100)
	#if Input.is_action_just_pressed("PUNCH_2"):
		#self.global_position -= Vector2(0,100)
	#print(self.global_position)
	
	# Modify camera position
	var center_players = tomato.global_position.lerp(banana.global_position, 0.5)
	var baricentric_center = center_scene.lerp(center_players, 0.5)
	# Smoothing motion
	var new_pos = self.global_position.lerp(baricentric_center, delta * FOLLOW_SPEED)
	position = Vector2(clamp(new_pos.x, position_x_range[0], position_x_range[1]), new_pos.y)
	
	## Modify camera zoom
	#var distance = 1000 / tomato.global_position.distance_to(banana.global_position) # divided by window width
	##var zoom_factor1 = abs(tomato.global_position.x-banana.global_position.x)/(1920-100)
	##var zoom_factor2 = abs(tomato.global_position.y-banana.global_position.y)/(1080-100)
	##var zoom_factor = max(max(zoom_factor1, zoom_factor2), 0.5)
	#print(distance)
	#var new_zoom = clamp(distance, zoom_range[0], zoom_range[1])
	#self.zoom = self.zoom.lerp(Vector2(new_zoom, new_zoom), delta * FOLLOW_SPEED/3)
	##self.zoom = Vector2(new_zoom, new_zoom)
	##self.zoom = Vector2(distance, distance)
	
	
	
	# Keep the camera centered between the targets
	#var p = Vector2.ZERO
	#for target in targets:
		#p += target.position
	#p /= targets.size()
	#position = lerp(position, p, FOLLOW_SPEED * delta)
	
	# find the zoom that will contain all targets
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		var a = r.size.x / screen_size.x
		var b = clamp(a, min_zoom, max_zoom)
		z = 1/b
		#z = 1 / clamp(r.size.y / screen_size.y, min_zoom, max_zoom)
	else:
		var a = r.size.y / screen_size.y
		var b = clamp(a, min_zoom, max_zoom)
		z = 1/b
		#z = 1 / clamp(r.size.y / screen_size.y, min_zoom, max_zoom)
		
	print(z)
	zoom = lerp(zoom, Vector2.ONE * z, FOLLOW_SPEED * delta)

func add_target(t):
	if not t in targets:
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.erase(t)
