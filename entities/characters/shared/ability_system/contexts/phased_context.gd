class_name PhasedContext extends CharacterAbilityContext

const SPAWN_CONTAINER_NAME := &"PhasedAbilitiesSpawnContainer"

var _host: CharacterBody3D
var _pivot: Node3D
var _buff_anchor: Node3D
var _anim_tree: AnimationTree
var _signals: CharacterAbilitySignals
var _camera_node: ThirdPersonCam
var _wandspawn_node: Node3D
var _ground_target_marker: Decal
var _enemy_target_marker: Sprite2D
var _viewport: Viewport
var _world_3d: World3D
var _spawn_container: Node3D

func _init(
	host: CharacterBody3D,
	pivot: Node3D,
	buff_anchor: Node3D,
	anim_tree: AnimationTree,
	signals: CharacterAbilitySignals,
	camera_node: ThirdPersonCam,
	wandspawn_node: Node3D,
	ground_target_marker: Decal,
	enemy_target_marker: Sprite2D,
	viewport: Viewport,
	world_3d: World3D,
	spawn_container: Node3D,
) -> void:
	_host = host
	_pivot = pivot
	_buff_anchor = buff_anchor
	_anim_tree = anim_tree
	_signals = signals
	_camera_node = camera_node
	_wandspawn_node = wandspawn_node
	_ground_target_marker = ground_target_marker
	_enemy_target_marker = enemy_target_marker
	_viewport = viewport
	_world_3d = world_3d
	_spawn_container = spawn_container

static func create(
	host: CharacterBody3D,
	pivot: Node3D,
	buff_anchor: Node3D,
	anim_tree: AnimationTree,
	signals: CharacterAbilitySignals,
	camera_node: ThirdPersonCam,
	wandspawn_node: Node3D,
	ground_target_marker: Decal,
	enemy_target_marker: Sprite2D,
	viewport: Viewport,
	world_3d: World3D,
) -> PhasedContext:
	var spawn_container := Node3D.new()
	host.add_child(spawn_container)
	
	spawn_container.top_level = true
	spawn_container.name = SPAWN_CONTAINER_NAME
	spawn_container.owner = host.get_tree().current_scene
	
	return PhasedContext.new(
		host,
		pivot,
		buff_anchor,
		anim_tree,
		signals,
		camera_node,
		wandspawn_node,
		ground_target_marker,
		enemy_target_marker,
		viewport,
		world_3d,
		spawn_container,
	)

func spawn_node(node: Node3D) -> void:
	_spawn_container.add_child(node)

func spawn_at_wand(node: Node3D) -> void:
	spawn_node(node)
	node.global_position = _wandspawn_node.global_position

func spawn_buff(node: Node3D) -> void:
	_buff_anchor.add_child(node)

func get_wandspawn_position() -> Vector3:
	return _wandspawn_node.global_position

func get_wand_transform() -> Transform3D:
	return _wandspawn_node.global_transform

func get_pivot_basis() -> Basis:
	return _pivot.global_basis

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

func notify_casting_started() -> void:
	_signals.ability_started.emit()

func notify_casting_progressed(current: float, total: float) -> void:
	_signals.ability_progressed.emit(current, total)

func notify_casting_end() -> void:
	_signals.ability_end.emit()

func raycast_from_mouse(ray_range: float, collision_mask: int = 0) -> Dictionary:
	var mouse_pos := _viewport.get_mouse_position()
	var camera := _viewport.get_camera_3d()
	
	var origin := camera.project_ray_origin(mouse_pos)
	var end := origin + camera.project_ray_normal(mouse_pos) * ray_range
	
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collision_mask = collision_mask
	
	return _world_3d.direct_space_state.intersect_ray(query)

func animate(ability: CharacterAbilityPhased) -> void:
	_anim_tree.set(ability.anim.trigger + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func unproject_position(position: Vector3) -> Vector2:
	return _viewport.get_camera_3d().unproject_position(position)

func get_animation_position(ability: CharacterAbilityPhased) -> float:
	var value = _anim_tree.get(ability.anim.trigger + "/current_position")
	
	return 0.0 if value == null else value

func update_cast_point(data: CharacterAbilityPhased) -> void:
	data.update_cast_point(_anim_tree)
