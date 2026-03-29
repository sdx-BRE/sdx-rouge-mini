class_name EnemyTargetMarkerOscillator extends ProcessHandler

const BASE := 0.1
const AMPLITUDE := 0.025
const FREQUENCY := 5.0

var _target_marker: Sprite2D
var _time := 0.0

func _init(target_marker: Sprite2D):
	_target_marker = target_marker

func process(delta: float) -> void:
	var factor := _oscillate(_time, BASE, AMPLITUDE, FREQUENCY)
	_target_marker.scale = Vector2.ONE * factor
	
	_time += delta

func _oscillate(
	t: float,
	base: float = 0.0,
	amplitude: float = 1.0,
	frequency: float = 1.0,
) -> float:
	return base + amplitude * sin(t * frequency)

