class_name MageAbilitySpell extends MageAbilityPhased

var _anim: MageSpellAnimation

func _init(
	controller: MageController,
	context: MageAbilityContext,
	cost: MageAbilityCost,
	anim: MageSpellAnimation
):
	super(controller, context, cost)
	_anim = anim

func tick_cast(_delta: float) -> void:
	_context.notify_casting_progressed(_anim)

class Instant extends MageAbilitySpell:
	func update(_delta: float) -> void: pass
	func cancel() -> void: pass
	func handle_input(_event: InputEvent) -> bool: return false
