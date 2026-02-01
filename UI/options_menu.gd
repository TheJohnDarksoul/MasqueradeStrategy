extends Control

@onready var music = $"Music Player"
@onready var m_slider = $"Music Slider"
var toggle = false

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")

func _on_toggle_fullscreen_pressed() -> void:
	toggle = !toggle
	if(toggle == true):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
