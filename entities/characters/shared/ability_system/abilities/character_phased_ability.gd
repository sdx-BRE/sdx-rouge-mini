class_name CharacterPhasedAbility extends CharacterAbility

var _context: PhasedContext
var _phased_data: CharacterAbilityPhased

func _init(data: CharacterAbilityPhased, stats: EntityStats, context: PhasedContext) -> void:
	super(data, stats)
	_context = context
	_phased_data = data

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
	_context.notify_casting_progressed(
		_context.get_animation_position(_phased_data),
		_phased_data.anim.cast_point,
	)

func cancel() -> void:
	push_error("[Error][CharacterPhasedAbility]: cancel() must be overwritten by child implementations")

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
