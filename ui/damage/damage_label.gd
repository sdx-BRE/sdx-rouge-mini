class_name DamageLabel extends Label

var _world_pos: Vector3
var _velocity: Vector2
var _current_offset: Vector2 = Vector2.ZERO
var _camera: Camera3D

func setup(amount: float, pos: Vector3, camera: Camera3D) -> void:
	_camera = camera
	
	text = str(round(amount))
	_world_pos = pos
	_velocity = Vector2(randf_range(-150, 150), randf_range(-200, -400))
	
	var tween := create_tween()
	tween.tween_property(self, "_velocity", Vector2(_velocity.x * 0.2, 0), 0.8).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.8).set_delay(0.2)
	tween.chain().tween_callback(queue_free)

func _process(delta: float) -> void:
	_current_offset += _velocity * delta
	
	if _camera.is_position_behind(_world_pos):
		visible = false
		return
		
	visible = true
	var screen_pos := _camera.unproject_position(_world_pos)
	global_position = screen_pos + _current_offset - (size / 2.0)

func _to_string() -> String:
	return "DamageLabel"
