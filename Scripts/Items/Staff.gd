class_name Staff extends Item

@export var amountHealed:int
@export var maxUses:int
var currentUses:int

func _init() -> void:
	itemFlag = itemType.STAFF
	currentUses = maxUses
