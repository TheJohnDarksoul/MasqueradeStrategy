extends Control

@onready var Item_Menu = $"."
func _on_button_pressed() -> void:
	Item_Menu.visible = !Item_Menu.visible
