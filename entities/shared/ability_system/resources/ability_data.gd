@tool
class_name AbilityData extends Resource

@export var cooldown: AbilityCooldown = AbilityCooldown.new()
@export var cost: AbilityCost = AbilityCost.new()
@export var targeting: AbilityTargeting
@export var trigger: AbilityTrigger
@export var windup: AbilityWindup
@export var delivery: AbilityDelivery

@export var id: StringName = &""
var input: StringName = &""

func to_ability(
	stats: EntityStats,
	cooldown_manager: CooldownManager,
) -> Ability:
	return Ability.new(stats, self, cooldown_manager)

func _get_property_list() -> Array[Dictionary]:
	var actions: Array[String] = [""]
	for property in ProjectSettings.get_property_list():
		if property.name.begins_with("input/"):
			var action_name = property.name.trim_prefix("input/")
			actions.append(action_name)
	
	var enum_string := ",".join(actions)
	
	return [{
		"name": "input",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": enum_string
	}]
