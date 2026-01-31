class_name Unit
extends Node2D

enum Armies {PLAYER_ARMY, COMPUTER_ARMY}

@export var UnitName:String = "Generic Goon"

@export var army:Armies = Armies.COMPUTER_ARMY

@export_category("Stats")
@export var maxHp:int = 10
@export var Str:int = 0
@export var Dex:int = 0
@export var Mag:int = 0
@export var Con:int = 0
@export var Agi:int = 0

var currentHp:int

#Don't know how to make a static const. Don't touch this at runtime
static var modifierTable:Array[int] = [-5, -5, -4, -4, -3, -3, -2, -2,
-1, -1, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5]

func _init() -> void:
	currentHp = maxHp

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	pass
