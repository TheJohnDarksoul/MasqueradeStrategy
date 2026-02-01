extends Control

@onready var Item_Menu = $ItemsMenu
@onready var Cur_Hp = $ItemsMenu/HP/CurrentHP
@onready var Max_Hp = $ItemsMenu/HP/MaxHp
@onready var Strength = $ItemsMenu/Strength/StrengthNum
@onready var Dexterity = $ItemsMenu/Dexterity/DexterityNum
@onready var Constitution = $ItemsMenu/Constitution/ConstitutionNum
@onready var Agility = $ItemsMenu/Agility/AgilityNum
@onready var Magic = $ItemsMenu/Magic/MagicNum
@onready var Level = $ItemsMenu/Level/LevelNum
@onready var Item1 = $ItemsMenu/ItemsBox/ItemSlot1
func _on_button_pressed() -> void:
	Item_Menu.visible = !Item_Menu.visible
	Cur_Hp.text = str(globs.selectedPlayer.currentHp)
	Max_Hp.text = str(globs.selectedPlayer.maxHp)
	Strength.text = str(globs.selectedPlayer.maxHp)
	Dexterity.text = str(globs.selectedPlayer.maxHp)
	Constitution.text = str(globs.selectedPlayer.maxHp)
	Agility.text = str(globs.selectedPlayer.maxHp)
	Magic.text = str(globs.selectedPlayer.maxHp)
	Level.text = str(globs.selectedPlayer.level)
	Item1.text = str(globs.selectedPlayer.inventory)
	#if(Item_Menu.visible == true):
		##print(str(globs.selectedPlayer.currentHp))
		#Cur_Hp = str(globs.selectedPlayer.currentHp)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("CombatMenu"):
		#Item_Menu.visible = !Item_Menu.visible
		#print("AAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		#print(size)
