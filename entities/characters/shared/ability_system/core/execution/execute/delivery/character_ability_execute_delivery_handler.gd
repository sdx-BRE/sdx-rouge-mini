class_name CharacterAbilityExecuteDeliveryHandler extends RefCounted

var _ability: CharacterAbility
var _context: CharacterAbilityExecuteContext

func _init(ability: CharacterAbility, context: CharacterAbilityExecuteContext) -> void:
	_ability = ability
	_context = context

func setup(_data: CharacterAbilityDelivery) -> void:
	pass

func execute(_aiming_result: CharacterAbilityAimingResult) -> void:
	pass

func release() -> void:
	pass

func tick(_delta: float) -> void:
	pass

func _setup_when_ability(node: Node, data: CharacterAbilityDelivery) -> void:
	_when_ability(node, data, _setup_ability)

func _launch_when_ability(node: Node, data: CharacterAbilityDelivery) -> void:
	_when_ability(node, data, _launch_ability)

func _setup_ability(ability: AbilityEntity, data: CharacterAbilityDelivery) -> void:
	ability.setup_character_ability(data, _context)

func _launch_ability(ability: AbilityEntity, data: CharacterAbilityDelivery) -> void:
	ability.launch_character_ability(data, _context)

func _when_ability(node: Node, data: CharacterAbilityDelivery, then: Callable) -> void:
	if node is AbilityEntity:
		then.call(node, data)

func _use_resources() -> void:
	if _ability._data.cost.type == AbilityCost.Type.Instant:
		_ability.use_resources()
