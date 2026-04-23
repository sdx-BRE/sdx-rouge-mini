class_name DamageLabel extends Label

var _world_pos: Vector3
var _offset: Vector2
var _camera: Camera3D

func setup(amount: float, pos: Vector3, offset: Vector2, camera: Camera3D) -> void:
	_camera = camera
	
	text = str(round(amount))
	_world_pos = pos
	_offset = offset
	
	scale = Vector2(0.1, 0.1)
	pivot_offset = size / 2.0
	
	_update_position()
	
	var tween := create_tween()
	
	tween.tween_property(self , "scale", Vector2(1.3, 1.3), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self , "scale", Vector2(1.0, 1.0), 0.2)
	
	tween.parallel().tween_property(self , "modulate:a", 0.0, 0.5).set_delay(0.5)
	tween.chain().tween_callback(queue_free)

func _process(_delta: float) -> void:
	_update_position()

func _update_position() -> void:
	if not _camera:
		return
		
	if _camera.is_position_behind(_world_pos):
		visible = false
		return
		
	visible = true
	var screen_pos := _camera.unproject_position(_world_pos)
	
	global_position = screen_pos + _offset - (size / 2.0)
	pivot_offset = size / 2.0

func _to_string() -> String:
	return "DamageLabel"
