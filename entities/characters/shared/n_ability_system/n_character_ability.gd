class_name NCharacterAbility extends RefCounted

var _data: NCharacterAbilityData

func _init(data: NCharacterAbilityData) -> void:
	_data = data

func get_input() -> StringName:
	return _data.input
