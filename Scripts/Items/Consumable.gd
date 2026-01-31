class_name Consumable extends Item

enum itemEffects {ITEM_HEAL}

@export var effect:itemEffects
@export var maxUses:int
var currentUses:int

func _init() -> void:
	itemFlag = itemType.CONSUME
	currentUses = maxUses
