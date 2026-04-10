@tool
class_name NCharacterAbilityData extends Resource

@export var targeting: NCharacterAbilityTargeting
@export var execution: NCharacterAbilityExecution
@export var effect: NCharacterAbilityEffect

@export_enum("attack", "dash", "jump", "sprint", "skill_1", "skill_2", "skill_3", "dbg") var input: String

var id: int

func to_ability(
	stats: EntityStats,
	context: CharacterAbilityContext,
) -> NCharacterAbility:
	return NCharacterAbility.new(self, stats)

func _get_property_list() -> Array[Dictionary]:
	var constants = NCharacaterAbilityId.new().get_script().get_script_constant_map()
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

func get_handler() -> NCharacterAbilityHandler.Execution:
	return execution.get_handler()
