class_name EntityDebuff extends RefCounted

signal started()
signal ended()
signal ticked()

var elapsed_time: float = 0.0
var duration: float = 0.0
var tick_interval: float = 0.0
var is_expired: bool = false

var _stats: EntityStats
var _time_since_last_tick: float = 0.0

func _init(stats: EntityStats, _duration: float, _tick_interval: float = 0.0) -> void:
	_stats = stats
	duration = _duration
	tick_interval = _tick_interval

func tick(delta: float) -> void:
	if is_expired:
		return
		
	elapsed_time += delta
	
	if tick_interval > 0.0:
		_time_since_last_tick += delta
		if _time_since_last_tick >= tick_interval:
			_time_since_last_tick -= tick_interval
			_on_tick()
	
	if elapsed_time >= duration:
		expire()

func expire() -> void:
	if is_expired:
		return
	is_expired = true
	_on_end()

# Virtual methods
func _on_start() -> void: started.emit()
func _on_tick() -> void: ticked.emit()
func _on_end() -> void: ended.emit()
