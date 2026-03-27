class_name MageAbilityInstantAnimated extends MageAbilityInstant

var _anim: MageAbilityAnimation

func _init(
	controller: MageController,
	context: MageAbilityContext,
	cost: MageAbilityCost,
	anim: MageAbilityAnimation,
) -> void:
	super(controller, context, cost)
	_anim = anim
