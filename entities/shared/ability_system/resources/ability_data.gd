@tool
class_name AbilityData extends Resource

@export var cooldown: float = 0.0
@export var cost: AbilityCost = AbilityCost.new()
@export var targeting: AbilityTargeting
@export var trigger: AbilityTrigger
@export var windup: AbilityWindup
@export var delivery: AbilityDelivery

@export_enum("attack", "dash", "jump", "sprint", "skill_1", "skill_2", "skill_3", "dbg") var input: String

var id: int

func to_ability(
	stats: EntityStats,
	cooldown_manager: CooldownManager,
) -> Ability:
	return Ability.new(stats, self, cooldown_manager)

func _get_property_list() -> Array[Dictionary]:
	var constants = AbilityId.new().get_script().get_script_constant_map()
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
