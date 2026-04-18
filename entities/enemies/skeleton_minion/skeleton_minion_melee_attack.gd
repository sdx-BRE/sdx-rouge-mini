class_name SkeletonMinionMeleeAttack extends StateContextAttack

var _animator: EnemyAnimator
var _oneshot_punch: StringName

func _init(animator: EnemyAnimator, oneshot_punch: StringName) -> void:
	_animator = animator
	_oneshot_punch = oneshot_punch

func try_attack(context: StateContext) -> void:
	context.rotate_to_target()
	if context.can_attack():
		_animator.oneshot_fire(_oneshot_punch)
		context.start_attack_cooldown()
