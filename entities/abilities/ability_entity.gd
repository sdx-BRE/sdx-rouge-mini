class_name AbilityEntity extends Area3D

@export var enable_debug := false
@onready var hitbox := $Hitbox

func launch_enemy_ability(data: CharacterAbilityDelivery, context: CharacterAbilityExecuteContext) -> void:
	if enable_debug:
		var err := DbgHelper.err("AbilityEntity.launch_enemy_ability", "must be overwritten by child implementations")
		push_error(err, " - data: ", data, ", context: ", context)

func setup_enemy_ability(data: CharacterAbilityDelivery, context: CharacterAbilityExecuteContext) -> void:
	if enable_debug:
		var err := DbgHelper.err("AbilityEntity.setup_enemy_ability", "must be overwritten by child implementations")
		push_error(err, " - data: ", data, ", context: ", context)

func setup_character_ability(data: CharacterAbilityDelivery, context: CharacterAbilityExecuteContext) -> void:
	if enable_debug:
		var err := DbgHelper.err("AbilityEntity.setup_character_ability", "must be overwritten by child implementations")
		push_error(err, " - data: ", data, ", context: ", context)

func launch_character_ability(data: CharacterAbilityDelivery, context: CharacterAbilityExecuteContext) -> void:
	if enable_debug:
		var err := DbgHelper.err("AbilityEntity.setup_character_ability", "must be overwritten by child implementations")
		push_error(err, " - data: ", data, ", context: ", context)
