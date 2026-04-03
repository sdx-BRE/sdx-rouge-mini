class_name CharacterPhasedAbility extends CharacterAbility

var _context: PhasedContext

func _init(data: CharacterAbilityData, stats: EntityStats, context: PhasedContext) -> void:
	super(data, stats)
	_context = context

func start() -> StartResult: 
	push_error("[Error][CharacterPhasedAbility]: start() must be overwritten by child implementations")
	return StartResult.HandleWithInput

func update(_delta: float) -> void: 
	push_error("[Error][CharacterPhasedAbility]: update() must be overwritten by child implementations")

func handle_input(_event: InputEvent) -> HandleInputResult:
	push_error("[Error][CharacterPhasedAbility]: handle_input() must be overwritten by child implementations")
	return HandleInputResult.Cancel

func execute() -> ExecuteResult: 
	push_error("[Error][CharacterPhasedAbility]: execute() must be overwritten by child implementations")
	return ExecuteResult.Cancel

func tick_cast(_delta: float) -> void: 
	push_error("[Error][CharacterPhasedAbility]: tick_cast() must be overwritten by child implementations")

func cancel() -> void:
	push_error("[Error][MageAbilityBase]: cancel() must be overwritten by child implementations")

func _can_handle(handler: CharacterAbilityHandler) -> bool:
	return handler is PhasedAbilityHandler

enum StartResult {
	HandleWithInput,
	BufferAbility,
}

enum HandleInputResult {
	Trigger,
	Cancel,
	Unhandled,
}

enum ExecuteResult {
	Trigger,
	Cancel,
}
