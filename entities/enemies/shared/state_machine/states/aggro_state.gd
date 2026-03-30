class_name AggroState extends StateBase

var _attack: AggroAttackTarget
var _chase: AggroChaseTarget

func _init(
	ctx: StateContext,
	attack: AggroAttackTarget,
	chase: AggroChaseTarget,
) -> void:
	super(ctx)
	_attack = attack
	_chase = chase

func process(delta: float) -> int:
	if not _ctx.has_target():
		return StateTransition.POP
	
	if _ctx.is_target_in_range(): _attack.process(delta)
	else: _chase.process(delta)
	
	return StateTransition.NONE
