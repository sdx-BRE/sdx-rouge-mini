class_name CharacterAbilityExecutePhase extends CharacterAbilityExecutionPhase

var _context: CharacterAbilityExecuteContext

var _delivery_handler: CharacterAbilityExecuteDeliveryHandler
var _trigger_handler: CharacterAbilityExecuteTriggerHandler

func _init(
	exec: CharacterAbilityExecuter,
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> void:
	super(exec, ability)
	_ability = ability
	_context = context

func start() -> void:
	_delivery_handler = _ability._data.delivery.create_handler(_context)
	_trigger_handler = _ability._data.trigger.create_handler(_exec.blackboard)
	
	_delivery_handler.cost_required.connect(_on_cost_required)
	_delivery_handler.continuous_cost_required.connect(_on_continuous_cost_required)
	
	_trigger_handler.triggered.connect(_on_triggered)
	_trigger_handler.finished.connect(_on_finished)
	
	_delivery_handler.setup(_ability._data.delivery)
	_trigger_handler.setup(_ability._data.trigger)
	
	_trigger_handler.start()

func tick(delta: float) -> void:
	_trigger_handler.tick(delta)

func release() -> void:
	_trigger_handler.release()

func cancel() -> void:
	_trigger_handler.cancel()

func _to_string() -> String:
	return "CharacterAbilityExecutionExecute"

func _on_cost_required() -> void:
	if _ability._data.cost.type == AbilityCost.Type.Instant:
		_ability.use_resources()

func _on_continuous_cost_required(delta: float) -> void:
	if _ability._data.cost.type == AbilityCost.Type.Tick:
		_ability.use_resources_delta(delta)

func _on_triggered() -> void:
	_delivery_handler.execute(_exec.blackboard.aiming_result)

func _on_finished() -> void:
	_delivery_handler.release()
	_exec.next_phase()
