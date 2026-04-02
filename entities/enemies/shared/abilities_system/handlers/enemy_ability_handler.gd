class_name EnemyAbilityHandler extends RefCounted

func setup(ability: EnemyBaseAbility) -> EnemyAbilityHandler:
	push_error("[Error][AbilityHandler]: setup() must be overwritten by child implementations, ability: ", ability)
	return null

func try_activate() -> void:
	push_error("[Error][AbilityHandler]: try_activate() must be overwritten by child implementations")
