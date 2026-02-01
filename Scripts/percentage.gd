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
	$HBoxContainer/HealthStat.text = str(globs.selectedEnemy.currentHp)
	$VBoxContainer/Strength.text = str(globs.selectedEnemy.Str)
	$VBoxContainer/Dexterity.text = str(globs.selectedEnemy.Dex)
	$VBoxContainer/Constitution.text = str(globs.selectedEnemy.Con)
	$VBoxContainer/Agility.text = str(globs.selectedEnemy.Agi)
	$VBoxContainer/Magic.text = str(globs.selectedEnemy.Mag)

func readyMenu(TilePos:Vector2i, Perc:float) -> void:
	self.setPercentagePosition(TilePos)
	self.setPercentage(Perc)
	self.setEnemyStats()
