class_name MageAbilityContext extends RefCounted

var _anim: MageAnimator
var _stats: MageStats
var _data: MageAbilityContextData
var _environment: MageAbilityContextEnvironment

func _init(
	anim: MageAnimator,
	stats: MageStats,
	data: MageAbilityContextData,
	environment: MageAbilityContextEnvironment,
):
	_anim = anim
	_stats = stats
	_data = data
	_environment = environment

func has_resources(cost: MageAbilityCost) -> bool:
	return _stats.has_mana(cost.mana) and _stats.has_stamina(cost.stamina)

func use_resources(cost: MageAbilityCost) -> void:
	_stats.use_mana(cost.mana)
	_stats.use_stamina(cost.stamina)

func get_cast_origin() -> Vector3:
	return _environment.wandspawn_node.global_position

func get_host_transform_basis() -> Basis:
	return _environment.pivot.global_basis

func get_forward() -> Vector3:
	return _environment.pivot.global_transform.basis.z

func get_dash_power() -> float:
	return _data.dash_power

func spawn_node(node: Node3D) -> void:
	_environment.spawn_node(node)

func request_oneshot_animation(property: StringName) -> void:
	_anim.request_oneshot_fire(property)

func play_full_body(to_node: StringName, mode: AnimationUtil.Play = AnimationUtil.Play.Travel) -> void:
	_anim.play_full_body(to_node, mode)

func show_ground_target_marker() -> void:
	_environment.ground_target_marker.visible = true

func hide_ground_target_marker() -> void:
	_environment.ground_target_marker.visible = false

func show_enemy_target_marker() -> void:
	_environment.enemy_target_marker.visible = true

func hide_enemy_target_marker() -> void:
	_environment.enemy_target_marker.visible = false

func use_visible_mouse() -> void:
	_environment.camera_node.use_visible_mouse()

func use_captured_mouse() -> void:
	_environment.camera_node.use_captured_mouse()

func set_decal_position(position: Vector3) -> void:
	_environment.ground_target_marker.global_position = position

func notify_casting_started() -> void:
	_environment.casting_started.emit()

func notify_casting_progressed(anim: MageSpellAnimation) -> void:
	_environment.casting_progressed.emit(
		_anim.get_current_position(anim.trigger),
		anim.cast_point,
	)

func notify_casting_end() -> void:
	_environment.casting_end.emit()

func raycast_from_mouse(ray_range: float, collision_mask: int = 0) -> Dictionary:
	var mouse_pos := _environment.viewport.get_mouse_position()
	var camera := _environment.viewport.get_camera_3d()
	
	var origin := camera.project_ray_origin(mouse_pos)
	var end := origin + camera.project_ray_normal(mouse_pos) * ray_range
	
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collision_mask = collision_mask
	
	return _environment.world_3d.direct_space_state.intersect_ray(query)

func unproject_position(position: Vector3) -> Vector2:
	return _environment.viewport.get_camera_3d().unproject_position(position)
