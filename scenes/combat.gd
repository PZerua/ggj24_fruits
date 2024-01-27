extends Node2D

var seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	seconds = 10
	$Timer.start()
	$Label.text = str(seconds)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if seconds == 0:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	seconds -= 1
	$Label.text = str(seconds)
