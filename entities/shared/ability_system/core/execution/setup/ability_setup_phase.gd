class_name AbilitySetupPhase extends AbilityExecutionPhase

var _context: AbilitySetupContext

var _windup_handler: AbilitySetupWindupHandler

func _init(
	exec: AbilityExecuter,
	ability: Ability,
	context: AbilitySetupContext,
) -> void:
	super(exec, ability)
	_context = context

func start() -> void:
	_windup_handler = _ability._data.windup.create_setup_handler(_context, _exec.blackboard)
	_windup_handler.setup(_ability._data.windup)
	
	_windup_handler.visual_ready.connect(_on_visual_ready)
	_windup_handler.start()

func _on_visual_ready() -> void:
	if _windup_handler.visual_ready.is_connected(_on_visual_ready):
		_windup_handler.visual_ready.disconnect(_on_visual_ready)
	_exec.next_phase()

func cancel() -> void:
	_windup_handler.cancel()
	_exec.abort()

func tick(delta: float) -> void:
	_windup_handler.tick(delta)

func animation_trigger() -> void:
	_windup_handler.trigger()

func hit_event(target: Node3D) -> void:
	_windup_handler.hit_event(target)

func _to_string() -> String:
	return "AbilityExecutionSetup"
