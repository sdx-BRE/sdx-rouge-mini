class_name MageProcessHandler extends ProcessHandler

var _anim: MageAnimator
var _abilities: MageAbilityHandler

func _init(
	anim: MageAnimator,
	abilities: MageAbilityHandler,
) -> void:
	_anim = anim
	_abilities = abilities

func process(delta: float) -> void:
	_anim.process(delta)
	_abilities.process_abilities(delta)
