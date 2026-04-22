class_name SkeletonMinionExecuteStrategy extends BaseEnemyExecuteStrategy

var _animator: EnemyAnimator
var _punch_oneshot_param: StringName

func _init(animator: EnemyAnimator, punch_param: StringName) -> void:
	super(null)
	_animator = animator
	_punch_oneshot_param = punch_param

func punch_attack() -> void:
	_animator.oneshot_fire(_punch_oneshot_param)
