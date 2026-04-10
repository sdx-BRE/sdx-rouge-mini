class_name NCharacterAbilityInstant extends RefCounted

var base: NCharacterAbility

func _init(ability: NCharacterAbility) -> void:
	base = ability

func trigger(state: NCharacterAbilitySystem.TriggerState) -> Result:
	push_error("[Error][CharacterInstantAbility]: trigger() must be overwritten by child implementations - state: ", state)
	return Result.NoCost

enum Result {
	Consume,
	NoCost,
}
