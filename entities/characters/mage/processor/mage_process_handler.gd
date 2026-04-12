class_name MageProcessHandler extends ProcessHandler

var _anim: MageAnimator
var _ability_system: CharacterAbilitySystem

func _init(
	anim: MageAnimator,
	ability_system: CharacterAbilitySystem,
) -> void:
	_anim = anim
	_ability_system = ability_system

func process(delta: float) -> void:
	_anim.process(delta)
	#_ability_system.tick(delta)
