extends HBoxContainer
@onready var tutorial_label = %TutorialLabel
@onready var continue_button = %ContinueButton
@onready var arrow = %Arrow2D
@onready var player = %CharacterBody2D
var index = 0
var tutorial_text = [
	"Welcome in SomethingAboutBlocks, a mediocre game about shapes....",
	"A shape",
	"A empty spot for a shape",
	"If you fill the gap with a shape...",
	"...you get a filled gap!",
	"Multiple filled gaps in a row disappear and give bonus points",
	"And now, play the game!"
]

func _ready():
	arrow.visible = false

func _on_continue_button_pressed() -> void:
	index += 1
	match index:
		1:
			arrow.position.x = 844.0
			arrow.position.y = 60.0
			arrow.visible = true
		2:
			arrow.position.x = 618.0
			arrow.position.y = 326.0
		3:
			arrow.visible = false
			player.GRAVITY = 15000
			print(index)
		4:
			print(index)
		5:
			continue_button.text = "Start Game"
		6:
			get_tree().change_scene_to_file("res://game.tscn")
			return
	tutorial_label.text = tutorial_text[index]
