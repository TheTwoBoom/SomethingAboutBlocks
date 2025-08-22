extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://tutorial.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
