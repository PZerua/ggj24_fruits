extends Control

var started := false
#var target_bck_volume := -18

# Called when the node enters the scene tree for the first time.
func _ready():
	started = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#if started and $MusicStream.volume_db != target_bck_volume:
		 #$MusicStream.volume_db = move_toward($MusicStream.volume_db, target_bck_volume, delta * 5.0)
	
	#if Input.is_action_pressed("Interact"):
		#World.global_player.character_enabled = true
		#$MenuAnimation.play("fade_out")
		#started = true

#func _on_menu_animation_animation_finished(_anim_name):
	#$Panel.visible = false

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/pre_game.tscn")
	started = true

func _on_exit_pressed():
	get_tree().quit()
