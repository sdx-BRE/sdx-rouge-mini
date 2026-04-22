class_name AbilitySetupMeleeHandler extends AbilitySetupWindupHandler

const FALLBACK_DURATION := 1.5

var _data: AbilityWindupMelee
var _timer: float = 0.0

func setup(data: AbilityWindup) -> void:
	_data = data

func start() -> void:
	_timer = FALLBACK_DURATION
	
	_context.animation_finished.connect(_on_animation_finished)
	_context.oneshot(_data.anim_trigger)

func tick(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		_finish()

func hit_event(target: Node3D) -> void:
	if not _blackboard.hit_targets.has(target):
		_blackboard.hit_targets.append(target)
	
	_finish()

func cancel() -> void:
	if _context.animation_finished.is_connected(_on_animation_finished):
		_context.animation_finished.disconnect(_on_animation_finished)
	_context.cancel_oneshot(_data.anim_trigger)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == _data.anim_name:
		_finish()

func _finish() -> void:
	if _context.animation_finished.is_connected(_on_animation_finished):
		_context.animation_finished.disconnect(_on_animation_finished)
	
	_emit_visual_ready()
