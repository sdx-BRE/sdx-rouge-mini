class_name DamageInstance extends RefCounted

var payloads: Array[DamagePayload] = []

func _init(_payloads: Array[DamagePayload] = []) -> void:
	payloads = _payloads

static func from_ability(ability_damage: AbilityDamage) -> DamageInstance:
	var mapped_payloads: Array[DamagePayload] = []
	
	for modifier in ability_damage.modifiers:
		var payload := modifier.to_payload()
		if payload:
			mapped_payloads.append(payload)
			
	return DamageInstance.new(mapped_payloads)
