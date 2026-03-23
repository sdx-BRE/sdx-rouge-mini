class_name MageAbilities

var _registry: Registry
var _active_ability: BaseAbility
var _buffered_ability: BaseAbility

func _init(registry: Registry) -> void:
	_registry = registry

static func create(mage: MageCharacter) -> MageAbilities:
	var player: AnimationPlayer = mage.anim_tree.get_node(mage.anim_tree.anim_player)

	var firebolt = Firebolt.new(mage, SpellAnimation.create(
		mage.firebolt_data,
		mage.animation_shoot,
		player,
	))
	
	var firepulse = Firepulse.new(mage, SpellAnimation.create(
		mage.firepulse_data,
		mage.animation_shoot,
		player,
	))
	
	var meteor = Meteor.new(mage, SpellAnimation.create(
		mage.meteor_data,
		mage.animation_raise,
		player,
	))
	
	var dash = Dash.new(mage)
	
	var reg = Registry.new()
	reg.add(Id.Firepulse, AbilityInfo.new(firepulse, ["attack", "skill_2"]))
	reg.add(Id.Firebolt, AbilityInfo.new(firebolt, ["skill_1"]))
	reg.add(Id.Meteor, AbilityInfo.new(meteor, ["skill_3"]))
	reg.add(Id.Dash, AbilityInfo.new(dash, ["dash"]))
	
	return MageAbilities.new(reg)

func prepare_ability(id: Id) -> void:
	var ability = _registry.get_ability(id)
	if ability == null:
		return
	
	if _active_ability != null:
		_active_ability.cancel()
	_active_ability = ability
	_active_ability.prepare()

func handle_input(event: InputEvent) -> bool:
	if _active_ability != null and _active_ability.handle_input(event):
		return true
	
	for action in _registry.actions:
		if event.is_action_pressed(action):
			prepare_ability(_registry.actions[action])
			return true
	
	return false

func preparing(delta: float) -> void:
	if _active_ability != null:
		_active_ability.preparing(delta)
	
	if _buffered_ability != null:
		_buffered_ability.casting()

func buffer_ability(ability: BaseAbility) -> void:
	if _buffered_ability != null:
		_buffered_ability.cancel()
	_buffered_ability = ability

func buffer_active_ability() -> void:
	if _active_ability != null:
		buffer_ability(_active_ability)
		_active_ability = null

func is_buffered(ability: BaseAbility) -> bool:
	return _buffered_ability == ability

func release() -> void:
	if _buffered_ability != null:
		_buffered_ability.release()
		_buffered_ability = null

func unset_when_active(ability: BaseAbility) -> void:
	if _active_ability == ability:
		_active_ability = null

class HasMage:
	var _mage: MageCharacter
	
	func _init(mage: MageCharacter):
		_mage = mage

enum Id {
	Firepulse,
	Firebolt,
	Meteor,
	Dash,
}
class AbilityInfo:
	var ability: BaseAbility
	var actions: Array[StringName]
	
	func _init(p_ability: BaseAbility, p_actions: Array[StringName]) -> void:
		ability = p_ability
		actions = p_actions

class Registry:
	var _abilities: Dictionary[Id, AbilityInfo]
	var actions: Dictionary[StringName, Id]
	
	func add(id: Id, ability: AbilityInfo) -> void:
		_abilities[id] = ability
		_build_actions_dict()
	
	func get_ability(id: Id) -> BaseAbility:
		return _abilities[id].ability
	
	func _build_actions_dict():
		var result: Dictionary[StringName, Id] = {}
		for idx in _abilities:
			for action in _abilities[idx].actions:
				result[action] = idx
		actions = result

class SpellAnimation:
	var scene: PackedScene
	var oneshot_prop: StringName
	var cast_point: float
	
	func _init(
		p_scene: PackedScene,
		p_oneshot_prop: StringName,
		p_cast_point: float
	) -> void:
		scene = p_scene
		oneshot_prop = p_oneshot_prop
		cast_point = p_cast_point
	
	static func create(
		resource: SpellResource,
		animation: SpellAnimationData,
		player: AnimationPlayer,
	) -> SpellAnimation:
		var c_point = animation.try_get_call_method_track_time(player)
		if c_point == null:
			c_point = 0.01
		
		return SpellAnimation.new(
			resource.scene,
			animation.oneshot_property,
			c_point,
		)

enum CQueueTask {
	FinishAttack,
}

#region spells
#region BaseAbility
class BaseAbility extends HasMage:
	func prepare() -> void: push_error("[BaseAbility].prepare() must be overriden by child implementations")
	func preparing(_delta: float) -> void: push_error("[BaseAbility].preparing() must be overriden by child implementations")
	func release() -> void: push_error("[BaseAbility].release() must be overriden by child implementations")
	func cancel() -> void: push_error("[BaseAbility].cancel() must be overriden by child implementations")
	func handle_input(_event: InputEvent) -> bool: 
		push_error("[BaseAbility].push_error() must be overriden by child implementations")
		return false
	func progress() -> void: push_error("[BaseAbility].progress() must be overriden by child implementations")
	
	func casting() -> void: push_error("[BaseAbility].casting() must be overriden by child implementations")
	
	func _init_at_wand_spawnpoint(scene: PackedScene) -> Node3D:
		var node = _init_scene(scene)
		node.global_position = _mage.wandspawn_node.global_position
		
		node.global_basis = _mage.pivot.global_basis
		node.global_basis = node.global_basis.rotated(Vector3.UP, PI)
		node.global_basis.z.y = 0
		node.global_basis = node.global_basis.orthonormalized()
		
		return node
	
	func _init_scene(scene: PackedScene) -> Node3D:
		var node = scene.instantiate()
		_mage.get_tree().current_scene.add_child(node)
		return node
#endregion

class SpellAbility extends BaseAbility:
	var anim: SpellAnimation
	
	func _init(mage: MageCharacter, p_anim: SpellAnimation):
		super(mage)
		anim = p_anim
	
	func casting() -> void:
		_mage.notify_casting_progressed(
			_mage.anim.get_current_position(anim.oneshot_prop),
			anim.cast_point,
		)

class InstantAbility extends BaseAbility:
	func preparing(_delta: float) -> void: pass
	func cancel() -> void: pass
	func handle_input(_event: InputEvent) -> bool: return false

class InstantSpell extends SpellAbility:
	func preparing(_delta: float) -> void: pass
	func cancel() -> void: pass
	func handle_input(_event: InputEvent) -> bool: return false

#region firepulse
class Firepulse extends InstantSpell:
	func release():
		_mage.notify_casting_end()
		var node = _init_at_wand_spawnpoint(anim.scene)
		node.scale = Vector3(3, 3, 3)
		
		var distance = 1.75
		var forward = _mage.pivot.global_transform.basis.z
		
		node.global_position += forward * distance
	
	func prepare() -> void:
		_mage.anim.request_oneshot_fire(anim.oneshot_prop)
		_mage.abilities.buffer_active_ability()
		_mage.notify_casting_started()
#endregion
#region firebolt
class Firebolt extends InstantSpell:
	func release():
		_mage.notify_casting_end()
		_init_at_wand_spawnpoint(anim.scene)
	
	func prepare():
		_mage.anim.request_oneshot_fire(anim.oneshot_prop)
		_mage.abilities.buffer_active_ability()
		_mage.notify_casting_started()
#endregion
#region meteor
class Meteor extends SpellAbility:
	var _aim_pos := Vector3.ZERO
	
	func release():
		_mage.notify_casting_end()
		
		var node = anim.scene.instantiate()
		node.position = _aim_pos
		_mage.get_tree().current_scene.add_child(node)
	
	func prepare():
		_mage.camera_node.use_visible_mouse()
		_mage.aim_decal.visible = true
	
	func cancel() -> void:
		_mage.camera_node.use_captured_mouse()
		_mage.aim_decal.visible = false
		_mage.abilities.unset_when_active(self)
	
	func handle_input(event: InputEvent) -> bool:
		if event.is_action_pressed("ui_cancel"):
			cancel()
			return true
		
		if event.is_action_pressed("attack"):
			_mage.anim.request_oneshot_fire(anim.oneshot_prop)
			_mage.camera_node.use_visible_mouse()
			_mage.aim_decal.visible = false
			
			_mage.abilities.buffer_active_ability()
			_mage.camera_node.use_captured_mouse()
			_mage.notify_casting_started()
			
			return true
		
		return false
	
	func preparing(_delta: float) -> void:
		var cast_range = 20.0 # Todo: replace with configurable value
		var mouse_pos = _mage.get_viewport().get_mouse_position()
		var camera = _mage.get_viewport().get_camera_3d()
		
		var origin = camera.project_ray_origin(mouse_pos)
		var end = origin + camera.project_ray_normal(mouse_pos) * cast_range
		
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collision_mask = Layers.COLLISION_WORLD
		
		var result = _mage.get_world_3d().direct_space_state.intersect_ray(query)
		
		if result:
			_mage.aim_decal.global_position = result.position
			_aim_pos = result.position
#endregion
#region dash
class Dash extends InstantAbility:
	func prepare() -> void:
		if _mage.controller.is_not_moving():
			return
		
		var forward_vector = _mage.pivot.global_transform.basis.z
		forward_vector.y = 0
		forward_vector = forward_vector.normalized()
		
		_mage.controller.push_dash_motion(forward_vector * _mage.dash_power)
#endregion
#endregion
