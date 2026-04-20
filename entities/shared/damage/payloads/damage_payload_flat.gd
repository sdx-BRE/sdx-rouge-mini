class_name DamagePayloadFlat extends DamagePayload

var amount: float = 0.0

func _init(_amount: float) -> void:
	amount = _amount

func get_immediate_damage() -> float:
	return amount
