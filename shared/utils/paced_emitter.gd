class_name PacedEmitter extends RefCounted

signal tick_triggered(current_count: int)
signal sequence_finished

var _total: int
var _duration: float
var _accumulator: float = 0.0
var _count: int = 0
var _is_active: bool = false

func _init(total: int, duration: float) -> void:
	_total = total
	_duration = duration

func start(total: int, duration: float) -> void:
	_total = total
	_duration = duration
	_count = 0
	_accumulator = 0.0
	_is_active = true

func restart() -> void:
	_count = 0
	_accumulator = 0.0
	_is_active = true

func process(delta: float) -> void:
	if not _is_active or _count >= _total or _duration <= 0:
		return

	var rate = float(_total) / _duration
	_accumulator += rate * delta
	
	while _accumulator >= 1.0 and _count < _total:
		tick_triggered.emit(_count)
		_count += 1
		_accumulator -= 1.0
	
	if _count >= _total:
		_is_active = false
		sequence_finished.emit()

func change_duration(duration: float) -> void:
	_duration = duration
