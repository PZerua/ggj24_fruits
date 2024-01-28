extends Control

var timer : float = 2.0
var current_line = 0

const lines = [
	"[miss grape enters the scene]",
	"Next in line awaits the duel between the contender Juan Tomato and the royal knight Henry Orange.",
	"The aim of this confrontation is to determine whether the esteemed designation of fruit shall be bestowed or withheld from all tomatoes within the realm.",
	"Combatants, prepare yourselves for the impending clash!"
]

func _ready():
	$Label.text = lines[current_line]
	
func _process(delta):
	timer -= delta
	if timer <= 0.0 or Input.is_action_pressed("PUNCH_1") or Input.is_action_pressed("PUNCH_2"):
		current_line += 1
		if current_line >= lines.size():
			print("Combat Started. Fight!")
			get_tree().change_scene_to_file("res://scenes/combat.tscn")
			return
		if current_line == 1:
			$AudioStreamPlayer2D.stream = load("res://assets/audio/grape_cinematic_med.ogg")
			timer = 4.0
		if current_line == 2:
			$AudioStreamPlayer2D.stream = load("res://assets/audio/grape_cinematic.ogg")
			timer = 6.0
		if current_line == 3:
			$AudioStreamPlayer2D.stream = load("res://assets/audio/grape_cinematic_short.ogg")
			timer = 3.0
		$AudioStreamPlayer2D.play()
		$Background.texture = load("res://assets/menus/Intro_02.png")
		$Label.text = lines[current_line]
