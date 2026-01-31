class_name Weapon extends Item

@export var damage:int
@export_enum("SWORD", "GUN", "TOME", "KNUCKLES") var weaponType:int
@export var accuracy:int
@export var weaponRange:int

func _init() -> void:
	itemFlag = itemType.WEAPON
