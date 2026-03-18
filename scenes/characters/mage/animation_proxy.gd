extends Node

@export var mage: MageCharacter

func execute_spell() -> void:
	DbgHelper.tprint("[AnimationProxy] - execute_spell()")
	mage.spell.release()
