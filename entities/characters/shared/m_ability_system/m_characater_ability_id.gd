class_name MCharacaterAbilityId extends RefCounted

const JUMP := 10
const SPRINT := 20
const DASH := 30
const FIREPULSE := 100
const FIREBOLT := 110
const METEOR := 120
const SPELL_SHIELD := 130

const DBG := 999

static func const_name(value: int) -> String:
	var constants = MCharacaterAbilityId.new().get_script().get_script_constant_map()
	for constant_name in constants:
		if constants[constant_name] == value:
			return constant_name
	
	return ""
