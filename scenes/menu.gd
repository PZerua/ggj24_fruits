extends Control

var started := false

func _ready():
	started = false
	Music.stream = load("res://assets/audio/EpiFrui-music_Nestor.ogg")
	Music.play()

func _process(_delta):
	pass

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/pre_game.tscn")
	started = true

func _on_exit_pressed():
	get_tree().quit()
	
func _on_controls_pressed():
	get_tree().change_scene_to_file("res://scenes/end_game.tscn")
