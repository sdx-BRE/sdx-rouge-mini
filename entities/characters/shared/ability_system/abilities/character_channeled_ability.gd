class_name CharacterChanneledAbility extends CharacterAbility

var _context: ChanneledContext

func _init(data: CharacterAbilityData, stats: EntityStats, context: ChanneledContext) -> void:
	super(data, stats)
	_context = context

func tick(delta: float) -> TickResult:
	push_error("[Error][CharacterChanneledAbility]: tick() must be overwritten by child implementations, delta: ", delta)
	return TickResult.NoCost

func end() -> void:
	push_error("[Error][CharacterChanneledAbility]: end() must be overwritten by child implementations")

func _can_handle(handler: CharacterAbilityHandler) -> bool:
	return handler is ChanneledAbilityHandler

enum TickResult {
	Consume,
	NoCost,
}
