class_name MageAbilities

var registry: Registry
var _active_spell: BaseSpell
var _buffered_spell: BaseSpell

func _init(p_registry: Registry) -> void:
	registry = p_registry

static func create(
	mage: MageCharacter
) -> MageAbilities:
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
	
	return MageAbilities.new(Registry.new(firebolt, firepulse, meteor))

func prepare_spell(spell: BaseSpell) -> void:
	if _active_spell != null:
		_active_spell.cancel()
	_active_spell = spell
	_active_spell.prepare()

func handle_input(event: InputEvent) -> bool:
	if _active_spell != null:
		return _active_spell.handle_input(event)
	return false

func preparing(delta: float) -> void:
	if _active_spell != null:
		_active_spell.preparing(delta)
	
	if _buffered_spell != null:
		_buffered_spell.casting()

func buffer_spell(spell: BaseSpell) -> void:
	if _buffered_spell != null:
		_buffered_spell.cancel()
	_buffered_spell = spell

func buffer_active_spell() -> void:
	if _active_spell != null:
		buffer_spell(_active_spell)
		_active_spell = null

func is_buffered(spell: BaseSpell) -> bool:
	return _buffered_spell == spell

func release() -> void:
	if _buffered_spell != null:
		_buffered_spell.release()
		_buffered_spell = null

func unset_when_active(spell: BaseSpell) -> void:
	if _active_spell == spell:
		_active_spell = null

class HasMage:
	var _mage: MageCharacter
	
	func _init(mage: MageCharacter):
		_mage = mage

class Registry:
	var bolt: Firebolt
	var pulse: Firepulse
	var meteor: Meteor
	
	func _init(p_bolt: Firebolt, p_pulse: Firepulse, p_meteor: Meteor) -> void:
		bolt = p_bolt
		pulse = p_pulse
		meteor = p_meteor

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
#region basespell
class BaseSpell extends HasMage:
	var anim: SpellAnimation
	
	func _init(mage: MageCharacter, p_anim: SpellAnimation):
		super(mage)
		anim = p_anim
	
	func prepare() -> void: push_error("[MageCharacter][Spell][BaseSpell].prepare() must be overriden by child implementations")
	func preparing(_delta: float) -> void: push_error("[MageCharacter][Spell][BaseSpell].preparing() must be overriden by child implementations")
	func release() -> void: push_error("[MageCharacter][Spell][BaseSpell].release() must be overriden by child implementations")
	func cancel() -> void: push_error("[MageCharacter][Spell][BaseSpell].cancel() must be overriden by child implementations")
	func handle_input(_event: InputEvent) -> bool: 
		push_error("[MageCharacter][Spell][BaseSpell].push_error() must be overriden by child implementations")
		return false
	func progress(): push_error("[MageCharacter][Spell][BaseSpell].progress() must be overriden by child implementations")
	
	func casting() -> void:
		_mage.notify_casting_progressed(
			_mage.anim.get_current_position(anim.oneshot_prop),
			anim.cast_point,
		)
	
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
class InstantSpell extends BaseSpell:
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
		_mage.abilities.buffer_active_spell()
		_mage.notify_casting_started()
#endregion
#region firebolt
class Firebolt extends InstantSpell:
	func release():
		_mage.notify_casting_end()
		_init_at_wand_spawnpoint(anim.scene)
	
	func prepare():
		_mage.anim.request_oneshot_fire(anim.oneshot_prop)
		_mage.abilities.buffer_active_spell()
		_mage.notify_casting_started()
#endregion
#region meteor
class Meteor extends BaseSpell:
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
			
			_mage.abilities.buffer_active_spell()
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
#endregion
