class_name AbilityDamageModifierFlat extends AbilityDamageModifier

@export var damage: float = 10.0

func to_payload() -> DamagePayload:
	return DamagePayloadFlat.new(damage)
