class_name SkeletonMinionAnimator extends RefCounted

var _tree: AnimationTree
var _full_body_playback: AnimationUtil.Playback
var _conditional_queue: ConditionalQueue

var blender: Blender
var paths: BlendPaths
var names: StateNames
var oneshots: OneShots

var is_attacking: bool = false

func _init(
	p_tree: AnimationTree,
	p_full_playback: AnimationUtil.Playback,
	p_conditional_queue: ConditionalQueue,
	p_blender: Blender,
	p_paths: BlendPaths,
	p_names: StateNames,
	p_oneshots: OneShots
) -> void:
	_tree = p_tree
	_full_body_playback = p_full_playback
	_conditional_queue = p_conditional_queue
	blender = p_blender
	paths = p_paths
	names = p_names
	oneshots = p_oneshots

#region Public API
func play_full_body(to_node: StringName, mode: AnimationUtil.Play = AnimationUtil.Play.Travel) -> void:
	_full_body_playback.play(to_node, mode)

func oneshot_hit_weak() -> void:
	_request_oneshot_fire(oneshots.hit_weak)

func oneshot_hit_strong() -> void:
	_request_oneshot_fire(oneshots.hit_strong)

func oneshot_spawn_air() -> void:
	_request_oneshot_fire(oneshots.spawn_air)

func oneshot_spawn_ground() -> void:
	_request_oneshot_fire(oneshots.spawn_ground)

func punch_attack() -> void:
	_queue_is_attacking_flag(oneshots.punch)
	_request_oneshot_fire(oneshots.punch)
#endregion

func process(delta: float): _conditional_queue.process(delta)

func _queue_is_attacking_flag(property: StringName) -> void:
	is_attacking = true
	_conditional_queue.queue(
		CQueue,
		CQueue.IsAttacking,
		ConditionalQueue.Task.when_started(
			func(_d) -> bool: return not _is_oneshot_active(property)
		),
		func(_d) -> void: is_attacking = false
	)

func _request_oneshot_fire(property: StringName) -> void:
	_tree.set(property + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _is_oneshot_active(property: StringName) -> bool:
	return _tree.get(property + "/active") as bool

enum CQueue {
	IsAttacking,
}

class Blender:
	var _host: CharacterBody3D
	var _tree: AnimationTree
	var _paths: BlendPaths
	
	func _init(h: CharacterBody3D, t: AnimationTree, p: BlendPaths) -> void:
		_host = h
		_tree = t
		_paths = p
	
	func blend_loco_move(value: float) -> void:
		_tree.set(_paths.locomotion_move, value)
	
	func blend_loco_timescale(value: float) -> void:
		_tree.set(_paths.locomotion_timescale, value)

class StateNames:
	var death: StringName
	func _init(d: StringName) -> void:
		death = d

class BlendPaths:
	var locomotion_move: StringName
	var locomotion_timescale: StringName
	
	func _init(loco_move: StringName, loco_time: StringName) -> void:
		locomotion_move = loco_move
		locomotion_timescale = loco_time

class OneShots:
	var hit_weak: StringName
	var hit_strong: StringName
	var spawn_air: StringName
	var spawn_ground: StringName
	var punch: StringName
	var kick: StringName
	
	func _init(hw: StringName, hs: StringName, sa: StringName, sg: StringName, p: StringName, k: StringName) -> void:
		hit_weak = hw
		hit_strong = hs
		spawn_air = sa
		spawn_ground = sg
		punch = p
		kick = k

class Builder:
	var _host: CharacterBody3D
	var _tree: AnimationTree
	var _full_playback: AnimationUtil.Playback
	
	var _p_loco_move: StringName
	var _p_loco_time: StringName
	
	var _s_death: StringName
	
	var _o_weak: StringName
	var _o_strong: StringName
	var _o_air: StringName
	var _o_ground: StringName
	var _o_punch: StringName
	var _o_kick: StringName

	func _init(host: CharacterBody3D, tree: AnimationTree) -> void:
		_host = host
		_tree = tree

	func set_playbacks(full: StringName) -> Builder:
		var full_body_playback = _tree.get(full)
		var prefix := "[ERROR][SkeletonMinionAnimator.Builder::set_playbacks('%s')]" % [full]
		
		assert(full_body_playback != null, "%s - full_body playback not found at '%s'" % [prefix, full])
		
		_full_playback = AnimationUtil.Playback.new(full_body_playback)
		return self

	func set_paths(loco_move: StringName, loco_time: StringName) -> Builder:
		_p_loco_move = loco_move
		_p_loco_time = loco_time
		return self

	func set_state_names(death: StringName) -> Builder:
		_s_death = death
		return self

	func set_oneshots(
		hit_weak: StringName,
		hit_strong: StringName,
		spawn_air: StringName,
		spawn_ground: StringName,
		punch: StringName,
		kick: StringName,
	) -> Builder:
		_o_weak = hit_weak
		_o_strong = hit_strong
		_o_air = spawn_air
		_o_ground = spawn_ground
		_o_punch = punch
		_o_kick = kick
		return self

	func build() -> SkeletonMinionAnimator:
		var paths_obj := BlendPaths.new(_p_loco_move, _p_loco_time)
		var states_obj := StateNames.new(_s_death)
		var oneshots_obj := OneShots.new(_o_weak, _o_strong, _o_air, _o_ground, _o_punch, _o_kick)
		var blender_obj := Blender.new(_host, _tree, paths_obj)
		var c_queue := ConditionalQueue.new()
		
		return SkeletonMinionAnimator.new(_tree, _full_playback, c_queue, blender_obj, paths_obj, states_obj, oneshots_obj)
