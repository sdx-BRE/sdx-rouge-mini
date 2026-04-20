class_name AbilityDamageModifierDot extends AbilityDamageModifier

@export var duration: float = 3.0
@export var tick_interval: float = 1.0
@export var tick_damage: float = 2.0

func _init() -> void:
	pass

func to_payload() -> DamagePayload:
	return DamagePayloadDot.new(duration, tick_interval, tick_damage)
