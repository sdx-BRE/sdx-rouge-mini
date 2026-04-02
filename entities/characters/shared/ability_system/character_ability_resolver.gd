class_name CharacterAbilityResolver extends RefCounted

func is_handling_active_ability(event: InputEvent) -> bool:
	return false

func try_activate(ability: CharacterAbility, state: CharacterAbilitySystem.TriggerState) -> void:
	
	pass
