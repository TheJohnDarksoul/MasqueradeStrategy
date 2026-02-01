extends Control

@onready var Item_Menu = $"."
@onready var Cur_Hp = $HP/CurrentHP
func _on_button_pressed() -> void:
	Item_Menu.visible = !Item_Menu.visible
	
	if(Item_Menu.visible == true):
		#Cur_Hp.text = 
		pass
		
