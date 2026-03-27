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

func show_decal() -> void:
	_environment.camera_node.use_visible_mouse()
	_environment.aim_decal.visible = true

func hide_decal() -> void:
	_environment.camera_node.use_captured_mouse()
	_environment.aim_decal.visible = false

func set_decal_position(position: Vector3) -> void:
	_environment.aim_decal.global_position = position

func notify_casting_started() -> void:
	_environment.casting_started.emit()

func notify_casting_progressed(anim: MageSpellAnimation) -> void:
	_environment.casting_progressed.emit(
		_anim.get_current_position(anim.trigger),
		anim.cast_point,
	)

func notify_casting_end() -> void:
	_environment.casting_end.emit()

func get_viewport() -> Viewport:
	return _environment.viewport

func get_world_3d() -> World3D:
	return _environment.world_3d
