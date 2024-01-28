extends Node2D

func _ready():
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D2.play("idle")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
