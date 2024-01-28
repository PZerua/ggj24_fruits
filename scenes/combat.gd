extends Node2D

var combat_ended : bool = false
var seconds = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	#$AudioBSO.play()
	$GUI/UI/ColorRect/AnimationPlayer.play("fade_in")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$GUI/UI/Label.text = str(floor($GUI/UI/Timer.time_left)+1)

func to_fruitality_state(winner):
	print("Ended!")
	# Hide elements
	$GUI/UI/FunnyBar.hide()
	$GUI/UI/Label.hide()
	# Change camera target
	%MultiTargetCamera.set_target(winner)
	# Stop timer
	$GUI/UI/Timer.stop()
	# Play text animation
	$GUI/UI/AnimatedSprite2D.play("fruitality_text")
	
	combat_ended = true
	
func end():
	$GUI/UI/ColorRect/AnimationPlayer.play("fade_out")

func _on_timer_timeout():
	var tomato_life = $Tomato.life_points
	var orange_life = $Banana.life_points
	if tomato_life > orange_life:
		to_fruitality_state($Tomato)
	else:
		to_fruitality_state($Banana)	
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://scenes/end_game.tscn")
