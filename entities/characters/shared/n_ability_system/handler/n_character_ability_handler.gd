class_name NCharacterAbilityHandler extends RefCounted

enum Execution {
	Channeled,
	Instant,
	Phased,
}

var _cooldown_manager: CooldownManager

func _init(
	cooldown_manager: CooldownManager,
) -> void:
	_cooldown_manager = cooldown_manager

func setup(ability: NCharacterAbility) -> void:
	push_error("[Error][CharacterAbilityHandler]: setup() must be overwritten by child implementations, ability: ", ability)

func try_activate(state: NCharacterAbilitySystem.TriggerState) -> void:
	push_error("[Error][CharacterAbilityHandler]: try_activate() must be overwritten by child implementations, state: ", state)
