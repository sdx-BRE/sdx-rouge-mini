class_name MageAbilityContextData extends RefCounted

var dash_power: float
var jump_power: float

func _init(
	p_dash_power: float,
	p_jump_power: float,
) -> void:
	dash_power = p_dash_power
	jump_power = p_jump_power

static func from_mage(mage: MageCharacter) -> MageAbilityContextData:
	return MageAbilityContextData.new(
		mage.data.dash_power,
		mage.data.jump_power,
	)
