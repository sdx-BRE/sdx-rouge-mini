class_name MageAbilityPhased extends MageAbilityBase

func start() -> StartResult: 
	push_error("[Error][MageAbilityPhased]: start() must be overwritten by child implementations")
	return StartResult.Handled

func update(_delta: float) -> void: 
	push_error("[Error][MageAbilityPhased]: update() must be overwritten by child implementations")

func handle_input(_event: InputEvent) -> HandleInputResult:
	push_error("[Error][MageAbilityPhased]: handle_input() must be overwritten by child implementations")
	return HandleInputResult.Cancel

func execute() -> void: 
	push_error("[Error][MageAbilityPhased]: execute() must be overwritten by child implementations")

func tick_cast(_delta: float) -> void: 
	push_error("[Error][MageAbilityPhased]: tick_cast() must be overwritten by child implementations")

enum StartResult {
	Handled,
	Cast,
}

enum HandleInputResult {
	Trigger,
	Cancel,
	Unhandled,
}
