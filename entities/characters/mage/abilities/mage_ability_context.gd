class_name MageAbilityContext extends RefCounted

var _mage: MageCharacter

func _init(mage: MageCharacter):
	_mage = mage

func has_resources(cost: MageAbilityCost) -> bool:
	return _mage.stats.has_enough_mana(cost.mana) and _mage.stats.has_enough_stamina(cost.stamina)

func use_resources(cost: MageAbilityCost) -> void:
	_mage.stats.use_mana(cost.mana)
	_mage.stats.use_stamina(cost.stamina)

func get_cast_origin() -> Vector3:
	return _mage.wandspawn_node.global_position

func get_host_transform_basis() -> Basis:
	return _mage.pivot.global_basis

func get_forward() -> Vector3:
	return _mage.pivot.global_transform.basis.z

func get_dash_power() -> float:
	return _mage.dash_power

func spawn_node(node: Node3D) -> void:
	_mage.get_tree().current_scene.add_child(node)

func request_oneshot_animation(property: StringName) -> void:
	_mage.anim.request_oneshot_fire(property)

func show_decal() -> void:
	_mage.camera_node.use_visible_mouse()
	_mage.aim_decal.visible = true

func hide_decal() -> void:
	_mage.camera_node.use_captured_mouse()
	_mage.aim_decal.visible = false

func set_decal_position(position: Vector3) -> void:
	_mage.aim_decal.global_position = position

func notify_casting_started() -> void:
	_mage.notify_casting_started()

func notify_casting_progressed(anim: MageSpellAnimation) -> void:
	_mage.notify_casting_progressed(
		_mage.anim.get_current_position(anim.oneshot_prop),
		anim.cast_point,
	)

func notify_casting_end() -> void:
	_mage.notify_casting_end()

func get_viewport() -> Viewport:
	return _mage.get_viewport()

func get_world_3d() -> World3D:
	return _mage.get_world_3d()
