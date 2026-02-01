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
@onready var Item2 = $ItemsMenu/ItemsBox/ItemSlot2
@onready var Item3 = $ItemsMenu/ItemsBox/ItemSlot3
@onready var Portrait = $CharacterPortrait/DommyMommy
func _on_button_pressed() -> void:
	Item_Menu.visible = !Item_Menu.visible
	Cur_Hp.text = str(globs.selectedPlayer.currentHp)
	Max_Hp.text = str(globs.selectedPlayer.maxHp)
	Strength.text = str(globs.selectedPlayer.maxHp)
	Dexterity.text = str(globs.selectedPlayer.maxHp)
	Constitution.text = str(globs.selectedPlayer.maxHp)
	Agility.text = str(globs.selectedPlayer.maxHp)
	Magic.text = str(globs.selectedPlayer.maxHp)
	#Level.text = str(globs.selectedPlayer.level)
	Item1.text = str(globs.selectedPlayer.inventory[0].name)
	Item2.text = ""
	Item3.text = ""
	Portrait.texture = globs.selectedPlayer.charPortrait

	#if(globs.selectedPlayer.inventory[1].name == null || globs.selectedPlayer.inventory[2].name == null):
		#Item2.text = ""
		#Item3.text = ""

func _on_move_pressed() -> void:
	print("Changed to Moving")
	#$Camera2D2/PlayerMenu.visible = !$Camera2D2/PlayerMenu.visible
	globs.current_state = globs.GameState.MOVING


func _on_skip_turn_pressed() -> void:
	#globs.char_to_act = []
	#globs.mvt_setup == false
	globs.eTurnSetup = true
	$".".visible = !$".".visible
	globs.current_state = globs.GameState.ENEMY_TURN
	#_on_main_enemy_turn()
	#globs.current_state = globs.GameState.BEGIN_TURN
