class_name MageAbilityInfo extends RefCounted

var ability: MageAbilityBase
var actions: Array[StringName]

func _init(p_ability: MageAbilityBase, p_actions: Array[StringName]) -> void:
	ability = p_ability
	actions = p_actions
