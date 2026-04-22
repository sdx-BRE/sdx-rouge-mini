class_name DamageInstance extends RefCounted

var _payloads: Array[DamagePayload] = []
var _trigger_hit_animation: bool = true

func _init(p_payloads: Array[DamagePayload] = [], p_trigger_hit_animation: bool = true) -> void:
	_payloads = p_payloads
	_trigger_hit_animation = p_trigger_hit_animation

static func from_ability(ability_damage: AbilityDamage) -> DamageInstance:
	var mapped_payloads: Array[DamagePayload] = []
	
	for modifier in ability_damage.modifiers:
		var payload := modifier.to_payload()
		if payload:
			mapped_payloads.append(payload)
			
	return DamageInstance.new(mapped_payloads, ability_damage.play_hit_animation)

func get_payloads() -> Array[DamagePayload]:
	return _payloads

func should_trigger_hit_animation() -> bool:
	return _trigger_hit_animation
