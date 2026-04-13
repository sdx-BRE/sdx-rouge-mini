class_name CharacterAbilityExecutionAimingContext extends RefCounted

var _camera_node: ThirdPersonCam
var _ground_target_marker: Decal
var _enemy_target_marker: Sprite2D
var _viewport: Viewport
var _world_3d: World3D

func _init(
	camera_node: ThirdPersonCam,
	ground_target_marker: Decal,
	enemy_target_marker: Sprite2D,
	viewport: Viewport,
	world_3d: World3D,
) -> void:
	_camera_node = camera_node
	_ground_target_marker = ground_target_marker
	_enemy_target_marker = enemy_target_marker
	_viewport = viewport
	_world_3d = world_3d

func use_visible_mouse(cursor_type: Cursor.Type = Cursor.Type.Pointer) -> void:
	_camera_node.use_visible_mouse(cursor_type)

func use_captured_mouse() -> void:
	_camera_node.use_captured_mouse()

func show_ground_target_marker() -> void:
	_ground_target_marker.visible = true

func hide_ground_target_marker() -> void:
	_ground_target_marker.visible = false

func set_ground_target_marker_position(position: Vector3) -> void:
	_ground_target_marker.global_position = position

func show_enemy_target_marker() -> void:
	_enemy_target_marker.visible = true

func hide_enemy_target_marker() -> void:
	_enemy_target_marker.visible = false

func set_enemy_target_marker_position(position: Vector2) -> void:
	_enemy_target_marker.global_position = position

func raycast_from_mouse(ray_range: float, collision_mask: int = 0) -> Dictionary:
	var mouse_pos := _viewport.get_mouse_position()
	var camera := _viewport.get_camera_3d()
	
	var origin := camera.project_ray_origin(mouse_pos)
	var end := origin + camera.project_ray_normal(mouse_pos) * ray_range
	
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collision_mask = collision_mask
	
	return _world_3d.direct_space_state.intersect_ray(query)

func unproject_position(position: Vector3) -> Vector2:
	return _viewport.get_camera_3d().unproject_position(position)
