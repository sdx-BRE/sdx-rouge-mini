class_name NCharacterAbilityPhased extends RefCounted

var base: NCharacterAbility
var _context: NCharacterAbilityContextPhased
var _execution_data: NCharacterAbilityExecutionPhased

func _init(ability: NCharacterAbility, context: NCharacterAbilityContextPhased) -> void:
	base = ability
	_context = context
	_execution_data = ability._data.execution as NCharacterAbilityExecutionPhased

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
		_context.get_animation_position(_execution_data),
		_execution_data.anim.cast_point,
	)

func cancel() -> void:
	push_error("[Error][CharacterPhasedAbility]: cancel() must be overwritten by child implementations")

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
