class_name MageAbilityContextData extends RefCounted

var dash_power: float

func _init(
	p_dash_power: float,
) -> void:
	dash_power = p_dash_power

static func from_mage(mage: MageCharacter) -> MageAbilityContextData:
	return MageAbilityContextData.new(
		mage.data.dash_power,
	)
