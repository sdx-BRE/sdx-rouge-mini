extends Node

@export var mage: MageCharacter
@export var ui: PlayerUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mage.health_changed.connect(ui.update_health)
	mage.mana_changed.connect(ui.update_mana)
	
	ui.skill_activated.connect(mage.processor.input.use_skill)
