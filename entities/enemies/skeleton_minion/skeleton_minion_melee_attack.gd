class_name SkeletonMinionMeleeAttack extends StateContextAttack

var _anim: SkeletonMinionAnimator

func _init(anim: SkeletonMinionAnimator) -> void:
	_anim = anim

func try_attack(context: StateContext) -> void:
	if not _anim.is_attacking and context._data.attack_cooldown <= 0:
		_anim.punch_attack()
		context._data.attack_cooldown = 3.0 # Todo: Fix hardcoded attack cooldown
