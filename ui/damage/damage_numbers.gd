extends CanvasLayer

@export var label_scene: PackedScene
@export var camera: Camera3D

@export var zone_size: Vector2 = Vector2(150.0, 100.0)
@export var tick_rate: float = 0.05
@export var min_distance: float = 30.0
@export var max_retries: int = 10

@onready var container := $Control

var _camera: Camera3D
var _damage_buffer: Array[Dictionary] = []
var _time_since_last_tick: float = 0.0

func _ready() -> void:
	if _setup_camera3d():
		DamageGateway.display_damage.connect(show_damage)

func show_damage(damage: float, position: Vector3) -> void:
	_damage_buffer.append({"amount": damage, "position": position})

func _process(delta: float) -> void:
	_time_since_last_tick += delta
	
	if _time_since_last_tick >= tick_rate and not _damage_buffer.is_empty():
		_time_since_last_tick = 0.0
		var data = _damage_buffer.pop_front()
		
		_spawn_label_from_buffer(data.amount, data.position)

func _spawn_label_from_buffer(amount: float, base_pos: Vector3) -> void:
	if _camera.is_position_behind(base_pos):
		return
		
	var base_screen_pos := _camera.unproject_position(base_pos)
	
	var rect_rect := Rect2(
		base_screen_pos.x - zone_size.x / 2.0,
		base_screen_pos.y - zone_size.y,
		zone_size.x,
		zone_size.y
	)
	
	var chosen_screen_pos := base_screen_pos
	
	for i in range(max_retries):
		var test_pos := Vector2(
			randf_range(rect_rect.position.x, rect_rect.end.x),
			randf_range(rect_rect.position.y, rect_rect.end.y)
		)
		
		var too_close := false
		
		for child in container.get_children():
			if child is DamageLabel:
				var child_center: Vector2 = child.global_position + (child.size / 2.0)
				
				if test_pos.distance_to(child_center) < min_distance:
					too_close = true
					break
					
		if not too_close:
			chosen_screen_pos = test_pos
			break
			
	var offset_2d := chosen_screen_pos - base_screen_pos
			
	var label := _create_label()
	
	container.add_child(label)
	label.setup(amount, base_pos, offset_2d, _camera)

func _create_label() -> DamageLabel:
	if label_scene == null:
		return DamageLabel.new()
	
	var label := label_scene.instantiate()
	
	if not label is DamageLabel:
		push_error("[DamageNumbers._create_label()]: label_scene MUST be DamageLabel scene!")
		return DamageLabel.new()
	
	return label

func _setup_camera3d() -> bool:
	if camera != null:
		_camera = camera
		return true
	
	var err_prefix := "[DamageNumbers._setup_camera3d]"
	
	var viewport := get_viewport()
	
	if viewport == null:
		push_error("%s: get_viewport() - viewport not found" % err_prefix)
		return false
	
	var cam := viewport.get_camera_3d()
	
	if cam == null:
		push_error("%s: viewport.get_camera_3d() - camera3d not found" % err_prefix)
		return false
	
	_camera = cam
	return true
