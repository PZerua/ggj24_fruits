extends Camera2D

var tomato
var banana
const center_scene = Vector2(600, 350)
const FOLLOW_SPEED = 2.5

func _ready():
	self.global_position = center_scene
	tomato = %Tomato
	banana = %Banana

func _process(delta):
	
	# Modify camera position
	#self.global_position = (tomato.global_position + banana.global_position) * 0.5
	var center_players = tomato.global_position.lerp(banana.global_position, 0.5)
	var baricentric_center = center_scene.lerp(center_players, 0.5)
	# Smoothing motion
	self.global_position = self.global_position.lerp(baricentric_center, delta * FOLLOW_SPEED)
	
	# Modify camera zoom
	var distance = (1080-400) / tomato.global_position.distance_to(banana.global_position) # divided by window width
	#var zoom_factor1 = abs(tomato.global_position.x-banana.global_position.x)/(1920-100)
	#var zoom_factor2 = abs(tomato.global_position.y-banana.global_position.y)/(1080-100)
	#var zoom_factor = max(max(zoom_factor1, zoom_factor2), 0.5)
	if distance > 0.5 and distance < 0.9:
		self.zoom = self.zoom.lerp(Vector2(distance, distance), delta * FOLLOW_SPEED)
		#self.zoom = Vector2(distance, distance)
