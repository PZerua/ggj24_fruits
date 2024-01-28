extends Node2D

var timer : float = 4.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSpritePinneapple.play("trial")
	$AnimatedSpriteGrape.play("idle")
	$AnimatedSpriteApple.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if $AnimatedSpritePinneapple.animation == "trial" && timer < 0:
		get_node("../FinalColorRect/FinalAnimationPlayer").play("fade_out")
