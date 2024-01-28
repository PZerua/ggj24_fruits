extends Control

var timer : float = 2.0
var current_line = 0

const lines = [
	"[miss grape enters the scene]",
	"Next in line awaits the duel between the contender Henry Tomato and the royal knight Gori Banana.",
	"The aim of this confrontation is to determine whether the esteemed designation of fruit shall be bestowed or withheld from all tomatoes within the realm.",
	"Combatants, prepare yourselves for the impending clash!"
]

func _ready():
	$Label.text = lines[current_line]

func _process(delta):
	timer -= delta
	if timer <= 0.0:
		current_line += 1
		if current_line >= lines.size():
			print("Combat Started. Fight!")
			get_tree().change_scene_to_file("res://scenes/combat.tscn")
			return
		$Background.texture = load("res://assets/menus/Intro_02.png")
		$Label.text = lines[current_line]
		timer = 5.0
