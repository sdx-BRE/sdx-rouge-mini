class_name SkeletonMinionMeleeAttack extends StateContextAttack

var _anim: SkeletonMinionAnimator

func _init(anim: SkeletonMinionAnimator) -> void:
	_anim = anim

func try_attack(context: StateContext) -> void:
	if context.can_attack():
		_anim.punch_attack()
		context.start_attack_cooldown()
