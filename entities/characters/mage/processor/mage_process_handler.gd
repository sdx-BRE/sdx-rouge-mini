class_name MageProcessHandler extends ProcessHandler

var _anim: MageAnimator
var _ability_system: MCharacterAbilitySystem

func _init(
	anim: MageAnimator,
	ability_system: MCharacterAbilitySystem,
) -> void:
	_anim = anim
	_ability_system = ability_system

func process(delta: float) -> void:
	_anim.process(delta)
	_ability_system.tick(delta)
