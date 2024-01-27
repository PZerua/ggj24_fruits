extends Node2D

var seconds = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/ColorRect/AnimationPlayer.play("fade_in")
	$Label.text = str(seconds)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func end():
	$CanvasLayer/ColorRect/AnimationPlayer.play("fade_out")

func _on_timer_timeout():
	#if seconds == 0:
		#end()
	#seconds -= 1
	$Label.text = str(seconds)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		$Timer.start()
	
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
