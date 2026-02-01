extends Control

@onready var Item_Menu = $ItemsMenu

func _on_button_pressed() -> void:
	Item_Menu.visible = !Item_Menu.visible

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("CombatMenu"):
		#Item_Menu.visible = !Item_Menu.visible
		#print("AAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		#print(size)
