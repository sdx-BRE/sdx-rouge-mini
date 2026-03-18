extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

class Spell extends HasMage:
	var registry: Registry
	var _equipped: BaseSpell
	var _attack_anim_names: Array[String]
	
	var _pool: Array[BaseSpell]
	
	func _init(mage: MageCharacter, attack_anim_names: Array[String]) -> void:
		super(mage)
		registry = Registry.new(mage)
		_attack_anim_names = attack_anim_names
	
	func start_casting(spell: BaseSpell):
		if _equipped != null:
			_equipped.cancel()
		
		_equipped = spell
		_equipped.start()
	
	func casting(delta: float) -> void:
		if _equipped != null:
			_equipped.casting(delta)
	
	func release() -> void:
		if _equipped != null:
			_pool.append(_equipped)
			_equipped = null
	
	func process() -> void:
		_pool.reverse()
		while not _pool.is_empty():
			var spell = _pool.pop_back()
			spell.release()
	
	func handle_input(event: InputEvent) -> bool:
		if _equipped != null:
			return _equipped.handle_input(event)
		
		return false
	
	func is_attack_anim_name(anim_name: StringName) -> bool:
		return _attack_anim_names.has(anim_name)
	
	class Registry:
		var bolt: Firebolt
		var pulse: Firepulse
		var meteor: Meteor
		
		func _init(mage: MageCharacter) -> void:
			bolt = Firebolt.new(mage)
			pulse = Firepulse.new(mage)
			meteor = Meteor.new(mage)
	
	class BaseSpell extends HasMage:
		func start() -> void: push_error("[MageCharacter][Spell][BaseSpell].start() must be overriden by child implementations")
		func casting(_delta: float) -> void: push_error("[MageCharacter][Spell][BaseSpell].casting() must be overriden by child implementations")
		func release() -> void: push_error("[MageCharacter][Spell][BaseSpell].release() must be overriden by child implementations")
		func cancel() -> void: push_error("[MageCharacter][Spell][BaseSpell].cancel() must be overriden by child implementations")
		func handle_input(_event: InputEvent) -> bool: 
			push_error("[MageCharacter][Spell][BaseSpell].push_error() must be overriden by child implementations")
			return false
		
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
		
		func _handle_upper_body_blend2():
			_mage.anim.blender.blend2_upper_body(1.0, 0.075)
			_mage.conditional_queue.queue(
				CQueueTask,
				CQueueTask.FinishAttack,
				func() -> bool: return _mage.spell.is_attack_anim_name(_mage.anim.get_current_node(Animator.PlaybackRegion.Upperbody)),
				func(): _mage.anim.blender.blend2_upper_body(0.0)
			)
	
	class InstantSpell extends BaseSpell:
		func casting(_delta: float) -> void: pass
		func cancel() -> void: pass
		func handle_input(_event: InputEvent) -> bool: return false
	
	class Firepulse extends InstantSpell:
		func release():
			var node = _init_at_wand_spawnpoint(_mage.firepulse_data.scene)
			node.scale = Vector3(3, 3, 3)
			
			var distance = 1.75
			var forward = _mage.pivot.global_transform.basis.z
			
			node.global_position += forward * distance
		
		func start():
			_handle_upper_body_blend2()
			_mage.anim.play_upper_body(_mage.state_name_shoot, AnimationUtil.Play.Start)
	
	class Firebolt extends InstantSpell:
		func release():
			_init_at_wand_spawnpoint(_mage.firebolt_data.scene)
		
		func start():
			_handle_upper_body_blend2()
			_mage.anim.play_upper_body(_mage.state_name_shoot, AnimationUtil.Play.Start)
	
	class Meteor extends BaseSpell:
		var _state: State
		var _handled := false
		
		func release():
			var node = _mage.meteor_data.scene.instantiate()
			
			var distance = 17.5
			var forward = _mage.pivot.global_transform.basis.z
			
			node.position += forward * distance
			_mage.get_tree().current_scene.add_child(node)
		
		func start():
			_handled = false
			_state = State.new()
			#_handle_upper_body_blend2()
			#_mage.anim.play_upper_body(_mage.state_name_raise, AnimationUtil.Play.Start)
		
		func handle_input(_event: InputEvent) -> bool:
			if _handled:
				return false
			
			_handle_upper_body_blend2()
			_mage.anim.play_upper_body(_mage.state_name_raise, AnimationUtil.Play.Start)
			
			_handled = true
			return true
		
		func casting(_delta: float) -> void:
			DbgHelper.tprint("update decal")
		
		class State:
			var _state: Base
			
			func process(delta: float):
				var new_state = _state.process(delta)
				if new_state != null:
					_state = new_state
			
			class Base:
				func process(_delta: float):
					pass 
			
			class Aim extends Base:
				func process(_delta: float):
					pass
			
			class Release extends Base:
				func process(_delta: float):
					pass
