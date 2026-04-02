class_name CharacterAbilityInfo extends RefCounted

var ability: CharacterAbility
var actions: Array[StringName]

func _init(p_ability: CharacterAbility, p_actions: Array[StringName]) -> void:
	ability = p_ability
	actions = p_actions
