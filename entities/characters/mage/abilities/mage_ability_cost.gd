class_name MageAbilityCost extends RefCounted

var mana: float
var stamina: float

func _init(m: float, s: float) -> void:
	mana = m
	stamina = s

func with_mana(value: float) -> MageAbilityCost:
	return MageAbilityCost.new(value, stamina)

func with_stamina(value: float) -> MageAbilityCost:
	return MageAbilityCost.new(mana, value)
