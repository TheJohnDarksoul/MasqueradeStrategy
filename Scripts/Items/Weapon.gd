class_name Weapon extends Item

##Amount of damage this weapon deals
@export var damage:int
##Category of weapon
@export_enum("SWORD", "GUN", "TOME", "KNUCKLES") var weaponType:int
##Base accuracy of the weapon
@export var accuracy:int
##Tiles away from the unit that can be attacked
@export var weaponRange:int

func _init() -> void:
	itemFlag = itemType.WEAPON
