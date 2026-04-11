class_name MCharacterAbility extends RefCounted

var _data: MCharacterAbilityData

func _init(
	data: MCharacterAbilityData,
) -> void:
	_data = data

func get_input() -> StringName:
	return _data.input
