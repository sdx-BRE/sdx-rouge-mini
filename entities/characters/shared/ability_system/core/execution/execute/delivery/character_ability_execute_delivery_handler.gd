class_name CharacterAbilityExecuteDeliveryHandler extends RefCounted

signal cost_required()
signal continuous_cost_required(delta: float)

var _context: CharacterAbilityExecuteContext

func _init(context: CharacterAbilityExecuteContext) -> void:
	_context = context

func setup(_data: CharacterAbilityDelivery) -> void:
	pass

func execute(_aiming_result: CharacterAbilityAimingResult) -> void:
	pass

func execute_tick(_timespan: float, aiming_result: CharacterAbilityAimingResult) -> void:
	execute(aiming_result)

func release() -> void:
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

func _emit_cost_required() -> void:
	cost_required.emit()

func _emit_continuous_cost_required(delta: float) -> void:
	continuous_cost_required.emit(delta)
