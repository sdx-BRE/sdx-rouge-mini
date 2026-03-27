class_name MageAbilityContext extends RefCounted

var _anim: MageAnimator
var _stats: MageStats
var _data: MageAbilityContextData

func _init(
	anim: MageAnimator,
	stats: MageStats,
	data: MageAbilityContextData,
):
	_anim = anim
	_stats = stats
	_data = data

func has_resources(cost: MageAbilityCost) -> bool:
	return _stats.has_mana(cost.mana) and _stats.has_stamina(cost.stamina)

func use_resources(cost: MageAbilityCost) -> void:
	_stats.use_mana(cost.mana)
	_stats.use_stamina(cost.stamina)

func get_cast_origin() -> Vector3:
	return _data.wandspawn_node.global_position

func get_host_transform_basis() -> Basis:
	return _data.pivot.global_basis

func get_forward() -> Vector3:
	return _data.pivot.global_transform.basis.z

func get_dash_power() -> float:
	return _data.dash_power

func spawn_node(node: Node3D) -> void:
	_data.spawn_node(node)

func request_oneshot_animation(property: StringName) -> void:
	_anim.request_oneshot_fire(property)

func show_decal() -> void:
	_data.camera_node.use_visible_mouse()
	_data.aim_decal.visible = true

func hide_decal() -> void:
	_data.camera_node.use_captured_mouse()
	_data.aim_decal.visible = false

func set_decal_position(position: Vector3) -> void:
	_data.aim_decal.global_position = position

func notify_casting_started() -> void:
	_data.casting_started.emit()

func notify_casting_progressed(anim: MageSpellAnimation) -> void:
	_data.casting_progressed.emit(
		_anim.get_current_position(anim.trigger),
		anim.cast_point,
	)

func notify_casting_end() -> void:
	_data.casting_end.emit()

func get_viewport() -> Viewport:
	return _data.viewport

func get_world_3d() -> World3D:
	return _data.world_3d
