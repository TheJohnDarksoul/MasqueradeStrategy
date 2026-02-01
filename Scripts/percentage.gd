extends Control

@onready var Text = $Percentage
#run order: on click run readyMenu and then set the visibility
#to make the whole menu visible, set {reference to this menu in scene}.is_visible_in_tree() = true
func setPercentage(Perc:float) -> void:
	
	if (0.0 < Perc and Perc <= 33.3):
		Text.text = "[color=#8B0000]"
	elif (33.3 < Perc and Perc <= 66.6):
		Text.text = "[color=#FFD700]"
	elif (66.6 < Perc and Perc <= 100.0):
		Text.text = "[color=228B22]"
	
	Text.text = Text.text + Perc + "[\\color]"
	
func setPercentagePosition(TilePosition:Vector2i) -> void:
	var temp = TilePosition + Vector2i(20, 0)
	self.set_position(temp)

func setEnemyStats() -> void:
	$HBoxContainer/HealthStat.text = str(globs.selectedPlayer.maxHP)
	$VBoxContainer/Strength.text = str(globs.selectedPlayer.Str)
	$VBoxContainer/Dexterity.text = str(globs.selectedPlayer.Dex)
	$VBoxContainer/Constitution.text = str(globs.selectedPlayer.Con)
	$VBoxContainer/Agility.text = str(globs.selectedPlayer.Agi)
	$VBoxContainer/Magic.text = str(globs.selectedPlayer.Mag)

func readyMenu(TilePos:Vector2i, Perc:float) -> void:
	self.setPercentagePosition(TilePos)
	self.setPercentage(Perc)
	self.setEnemyStats()

#Open the menu for the Combat Scene. 
func _on_attack_pressed() -> void:
	pass # Replace with function body.
