class_name EnemyAnimationHandler extends ProcessHandler

var _anim: EnemyAnimation

func _init(anim: EnemyAnimation) -> void:
	_anim = anim

func process(delta: float) -> void:
	_anim.tick(delta)
