class_name MageMotor extends RefCounted

signal jumped()

var _ctx: MageMovementContext

var _jump_gates: Array[Callable]

func _init(context: MageMovementContext) -> void:
	_ctx = context
	
	add_jump_gate(func() -> bool: return _ctx.motion.jump_buffer_timer)
	add_jump_gate(func() -> bool: return _ctx.motion.coyote_timer > 0)

func apply_impulses(_delta: float) -> void:
	if _can_jump():
		_ctx.host.velocity.y = _ctx.config.get_jump_impulse_velocity()
		_ctx.motion.coyote_timer = 0
		_ctx.motion.jump_buffer_timer = 0
		
		jumped.emit()

func add_jump_gate(jump_gate: Callable) -> void:
	_jump_gates.append(jump_gate)

func _can_jump() -> bool:
	for gate in _jump_gates:
		if not gate.call():
			return false
	return true
