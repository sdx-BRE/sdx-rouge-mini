class_name AbilityExecuteDeliveryHandler extends RefCounted

signal cost_required()
signal continuous_cost_required(delta: float)

var _context: AbilityExecuteContext
var _blackboard: AbilityExecutionBlackboard

func _init(
	context: AbilityExecuteContext,
	blackboard: AbilityExecutionBlackboard,
) -> void:
	_context = context
	_blackboard = blackboard

func setup(_data: AbilityDelivery) -> void:
	pass

func execute(_aiming_result: AbilityAimingResult) -> void:
	pass

func execute_tick(_timespan: float, aiming_result: AbilityAimingResult) -> void:
	execute(aiming_result)

func release() -> void:
	pass

func _setup_when_ability(node: Node, data: AbilityDelivery) -> void:
	_when_ability(node, data, _setup_ability)

func _launch_when_ability(node: Node, data: AbilityDelivery) -> void:
	_when_ability(node, data, _launch_ability)

func _setup_ability(ability: AbilityEntity, data: AbilityDelivery) -> void:
	_context.setup_ability(ability, data)

func _launch_ability(ability: AbilityEntity, data: AbilityDelivery) -> void:
	_context.launch_ability(ability, data)

func _when_ability(node: Node, data: AbilityDelivery, then: Callable) -> void:
	if node is AbilityEntity:
		then.call(node, data)

func _emit_cost_required() -> void:
	cost_required.emit()

func _emit_continuous_cost_required(delta: float) -> void:
	continuous_cost_required.emit(delta)
