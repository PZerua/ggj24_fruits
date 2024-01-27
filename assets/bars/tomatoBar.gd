extends TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = %Tomato.funny;
	if value == 100:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
