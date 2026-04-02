class_name CharacterAbilityHandler extends RefCounted

func try_activate(state: CharacterAbilitySystem.TriggerState) -> void:
	push_error("[Error][CharacterAbilityHandler]: try_activate() must be overwritten by child implementations, state: ", state)

func setup(ability: CharacterAbility) -> CharacterAbilityHandler:
	push_error("[Error][CharacterAbilityHandler]: setup() must be overwritten by child implementations, ability: ", ability)
	return self
