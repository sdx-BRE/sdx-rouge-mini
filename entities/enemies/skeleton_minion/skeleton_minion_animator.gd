class_name SkeletonMinionAnimator extends RefCounted

var _tree: AnimationTree
var _full_body_playback: AnimationUtil.Playback
var _upper_body_playback: AnimationUtil.Playback
var _conditional_queue: ConditionalQueue

var blender: Blender
var paths: BlendPaths
var names: StateNames
var oneshots: OneShots

var is_attacking: bool = false

func _init(
	p_tree: AnimationTree,
	p_full_playback: AnimationUtil.Playback,
	p_upper_playback: AnimationUtil.Playback,
	p_conditional_queue: ConditionalQueue,
	p_blender: Blender,
	p_paths: BlendPaths,
	p_names: StateNames,
	p_oneshots: OneShots
) -> void:
	_tree = p_tree
	_full_body_playback = p_full_playback
	_upper_body_playback = p_upper_playback
	_conditional_queue = p_conditional_queue
	blender = p_blender
	paths = p_paths
	names = p_names
	oneshots = p_oneshots

#region Public API
func play_full_body(to_node: StringName, mode: AnimationUtil.Play = AnimationUtil.Play.Travel) -> void:
	_full_body_playback.play(to_node, mode)

func play_upper_body(to_node: StringName, mode: AnimationUtil.Play = AnimationUtil.Play.Travel) -> void:
	_upper_body_playback.play(to_node, mode)

func oneshot_hit_weak() -> void:
	_tree.set(oneshots.hit_weak, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func oneshot_hit_strong() -> void:
	_tree.set(oneshots.hit_strong, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func oneshot_spawn_air() -> void:
	_tree.set(oneshots.spawn_air, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func oneshot_spawn_ground() -> void:
	_tree.set(oneshots.spawn_ground, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func dev_attack() -> void:
	blender.instant_upper_blend(1.0)
	_upper_body_playback.play(names.upper_body.punch, AnimationUtil.Play.Travel)

func punch_attack() -> void:
	_handle_attack_upper_body_blend(names.upper_body.punch)
	_upper_body_playback.play(names.upper_body.punch, AnimationUtil.Play.Start)
#endregion

func process(delta: float): _conditional_queue.process(delta)

func _handle_attack_upper_body_blend(attack_anim_name: StringName):
	is_attacking = true
	blender.set_upper_blend(1.0)
	_conditional_queue.queue(
		CQueue,
		CQueue.UpperBodyBlend,
		func(_delta, task: ConditionalQueue.ConditionalQueueTask) -> bool:
			var anim_name = _upper_body_playback.get_current_node()
			var is_attack = anim_name == attack_anim_name
			var is_started = task.data.get("started", false)
			
			if is_attack and not is_started:
				task.data.set("started", true)
				return false
			
			return is_started and not is_attack,
		func(_d):
			blender.set_upper_blend(0.0)
			is_attacking = false,
	)

enum CQueue {
	UpperBodyBlend,
}

class Blender:
	var _host: CharacterBody3D
	var _tree: AnimationTree
	var _paths: BlendPaths
	
	func _init(h: CharacterBody3D, t: AnimationTree, p: BlendPaths) -> void:
		_host = h
		_tree = t
		_paths = p
	
	func blend_loco(value: float) -> void:
		_tree.set(_paths.locomotion, value)
	
	func set_upper_blend(value: float, duration: float = 0.1) -> void:
		var tween = _host.create_tween()
		tween.tween_property(_tree, NodePath(_paths.upper_body_blend2), value, duration)

class StateNames:
	var full_body: FullBody
	var upper_body: UpperBody
	
	func _init(fb: FullBody, ub: UpperBody) -> void:
		full_body = fb
		upper_body = ub
	
	class FullBody:
		var death: StringName
		func _init(d: StringName) -> void:
			death = d
			
	class UpperBody:
		var idle: StringName
		var punch: StringName
		var kick: StringName
		func _init(i: StringName, p: StringName, k: StringName) -> void:
			idle = i
			punch = p
			kick = k

class BlendPaths:
	var locomotion: StringName
	var upper_body_blend2: StringName
	
	func _init(loco: StringName, blend: StringName) -> void:
		locomotion = loco
		upper_body_blend2 = blend

class OneShots:
	var hit_weak: StringName
	var hit_strong: StringName
	var spawn_air: StringName
	var spawn_ground: StringName
	
	func _init(hw: StringName, hs: StringName, sa: StringName, sg: StringName) -> void:
		hit_weak = hw
		hit_strong = hs
		spawn_air = sa
		spawn_ground = sg

class Builder:
	var _host: CharacterBody3D
	var _tree: AnimationTree
	var _full_playback: AnimationUtil.Playback
	var _upper_playback: AnimationUtil.Playback
	
	var _p_loco: StringName
	var _p_blend: StringName
	
	var _s_death: StringName
	var _s_idle: StringName
	var _s_punch: StringName
	var _s_kick: StringName
	
	var _o_weak: StringName
	var _o_strong: StringName
	var _o_air: StringName
	var _o_ground: StringName

	func _init(host: CharacterBody3D, tree: AnimationTree) -> void:
		_host = host
		_tree = tree

	func set_playbacks(full: StringName, upper: StringName) -> Builder:
		var full_body_playback = _tree.get(full)
		var upper_body_playback = _tree.get(upper)
		var prefix = "[ERROR][SkeletonMinionAnimator.Builder::set_playbacks('%s', '%s')]" % [full, upper]
		
		assert(full_body_playback != null, "%s - full_body playback not found at '%s'" % [prefix, full])
		assert(upper_body_playback != null, "%s - upper_body playback not found at '%s'" % [prefix, upper])
		
		_full_playback = AnimationUtil.Playback.new(full_body_playback)
		_upper_playback = AnimationUtil.Playback.new(upper_body_playback)
		return self

	func set_paths(loco: StringName, blend: StringName) -> Builder:
		_p_loco = loco
		_p_blend = blend
		return self

	func set_state_names(death: StringName, idle: StringName, punch: StringName, kick: StringName) -> Builder:
		_s_death = death
		_s_idle = idle
		_s_punch = punch
		_s_kick = kick
		return self

	func set_oneshots(hit_weak: StringName, hit_strong: StringName, spawn_air: StringName, spawn_ground: StringName) -> Builder:
		_o_weak = hit_weak
		_o_strong = hit_strong
		_o_air = spawn_air
		_o_ground = spawn_ground
		return self

	func build() -> SkeletonMinionAnimator:
		var paths_obj = BlendPaths.new(_p_loco, _p_blend)
		var states_obj = StateNames.new(
			StateNames.FullBody.new(_s_death),
			StateNames.UpperBody.new(_s_idle, _s_punch, _s_kick)
		)
		var oneshots_obj = OneShots.new(_o_weak, _o_strong, _o_air, _o_ground)
		var blender_obj = Blender.new(_host, _tree, paths_obj)
		var c_queue = ConditionalQueue.new()
		
		return SkeletonMinionAnimator.new(_tree, _full_playback, _upper_playback, c_queue, blender_obj, paths_obj, states_obj, oneshots_obj)
