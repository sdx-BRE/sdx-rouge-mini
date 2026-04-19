class_name DamageInstance extends RefCounted

var amount: float = 0.0

func _init(_amount: float) -> void:
	amount = _amount

static func from_ability(ability_damage: AbilityDamage) -> DamageInstance:
	var final_amount = ability_damage.base_damage
	return DamageInstance.new(final_amount)
