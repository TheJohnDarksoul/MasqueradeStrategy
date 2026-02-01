class_name Unit
extends Node2D


enum Armies {PLAYER_ARMY, COMPUTER_ARMY}

##Displayed unit name
@export var UnitName:String = "Generic Goon"

@export var army:Armies = Armies.COMPUTER_ARMY

@export_category("Stats")
##Max hp value for this unit
@export var maxHp:int = 10
##Unit's strength stat
@export var Str:int = 0
##Unit's dexterity stat
@export var Dex:int = 0
##Unit's magic stat
@export var Mag:int = 0
##Unit's constitution stat
@export var Con:int = 0
##Unit's agility stat
@export var Agi:int = 0

var currentHp:int

@export_category("Unit Data")
##An array of Items in the unit's inventory
@export var level:int = 1
@export var inventory:Array[Item]

##Holds shared class attributes
@export var unitClass:UnitClass

##Holds unit portrait, not map sprite
@export var charPortrait:CompressedTexture2D

#Don't know how to make a static const. Don't touch this at runtime
static var modifierTable:Array[int] = [-5, -5, -4, -4, -3, -3, -2, -2,
-1, -1, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5]

func _ready() -> void:
	add_to_group("units")

func _init() -> void:
	currentHp = maxHp

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	pass

#This function assumes that the first item is a weapon
func calcDamage():
	var dmg
	#var def
	if inventory[0].weaponType == globs.weaponTypes.TOME:
		dmg = Mag
	else:
		dmg = Str
	dmg += inventory[0].damage
	return dmg

func takeDamage(dmg:int):
	currentHp -= dmg
	
	if currentHp <= 0:
		queue_free()
