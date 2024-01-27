extends Node2D

var seconds = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI/ColorRect/AnimationPlayer.play("fade_in")
	$GUI/Label.text = str(seconds)	
	$MultiTargetCamera.add_target($Tomato)
	$MultiTargetCamera.add_target($Banana)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func end():
	$GUI/ColorRect/AnimationPlayer.play("fade_out")

func _on_timer_timeout():
	#if seconds == 0:
		#end()
	#seconds -= 1
	$GUI/Label.text = str(seconds)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		$GUI/Timer.start()
	
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
