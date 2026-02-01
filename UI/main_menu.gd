extends Control


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/OptionsMenu.tscn")


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level.tscn")
