class_name Unit
extends Node2D

@export var UnitName:String

@export_category("Stats")
@export var maxHp:int = 10
@export var Str:int = 0
@export var Dex:int = 0
@export var Mag:int = 0
@export var Con:int = 0
@export var Agi:int = 0

static var modifierTable:Array[int] = []

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	pass
