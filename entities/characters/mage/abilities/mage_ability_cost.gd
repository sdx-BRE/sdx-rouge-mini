class_name MageAbilityCost extends RefCounted

var _mana: float
var _stamina: float

func _init(mana: float, stamina: float) -> void:
	_mana = mana
	_stamina = stamina

func with_mana(mana: float) -> MageAbilityCost:
	return MageAbilityCost.new(mana, _stamina)

func with_stamina(stamina: float) -> MageAbilityCost:
	return MageAbilityCost.new(_mana, stamina)
