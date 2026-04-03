@tool
class_name CharacterAbilityData extends Resource

@export var cost: AbilityCost
@export var damage: float = 1.0
@export_enum("attack", "dash", "jump", "skill_1", "skill_2", "skill_3") var input: String

var id: int

func _get_property_list() -> Array[Dictionary]:
	var constants = CharacterAbilityId.new().get_script().get_script_constant_map()
	var hint_strings := []
	for key in constants.keys():
		hint_strings.append(str(key, ":", constants[key]))
	
	var enum_string := ",".join(hint_strings)
	
	return [{
		"name": "id",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": enum_string
	}]
