class_name MageAbilityMeteor extends MageAbilitySpell

var _aim_pos := Vector3.ZERO

func execute() -> void:
	_context.notify_casting_end()
	
	var node := _anim.scene.instantiate()
	node.position = _aim_pos
	_context.spawn_node(node)

func start() -> MageAbilityPhased.StartResult:
	_context.show_decal()
	
	return MageAbilityPhased.StartResult.Handled

func cancel() -> void:
	_context.hide_decal()

func handle_input(event: InputEvent) -> HandleInputResult:
	if event.is_action("ui_cancel"): return HandleInputResult.Cancel
	
	if event.is_action_pressed("attack"):
		_context.request_oneshot_animation(_anim.trigger)
		_context.hide_decal()
		_context.notify_casting_started()
		
		return HandleInputResult.Trigger
	
	return HandleInputResult.Unhandled

func update(_delta: float) -> void:
	var cast_range := 20.0 # Todo: replace with configurable value
	var viewport := _context.get_viewport()
	var mouse_pos := viewport.get_mouse_position()
	var camera := viewport.get_camera_3d()
	
	var origin := camera.project_ray_origin(mouse_pos)
	var end := origin + camera.project_ray_normal(mouse_pos) * cast_range
	
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collision_mask = Layers.COLLISION_WORLD
	
	var result := _context.get_world_3d().direct_space_state.intersect_ray(query)
	
	if result:
		_context.set_decal_position(result.position)
		_aim_pos = result.position
