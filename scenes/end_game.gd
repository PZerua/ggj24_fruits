extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$FinalColorRect/FinalAnimationPlayer.play("fade_in")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
