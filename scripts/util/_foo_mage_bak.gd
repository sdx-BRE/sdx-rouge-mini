extends CharacterBody3D
class_name MageCharacterBak

@export_group("Debug Tools")
@export var debug_mode: bool = false

@export_group("Player properties")
@export var max_speed = 5.0
@export var jump_velocity = 4.5

@export_group("Movement - Dash")
@export var dash_power: float = 20.0
@export var dash_decay: float = 8.0

@export_group("Camera")
@export var camera_node: Marker3D

@export_group("Look At")
@export var reverse_axis := true
@export var look_at_weight := 10.0

@export_group("Animation - General")
@export var anim_tree: AnimationTree
@export var path_playback_full_body: String
@export var path_playback_right_arm: String
@export var path_full_body_locomotion_blend: String
@export var path_full_body_dash_blend: String
@export var path_right_arm_blend: String

@export_group("Animation - Full body")
@export var state_name_jump: String
@export var state_name_jump_idle: String
@export var state_name_land: String
@export var state_name_dash: String

@export_group("Animation - Right arm")
@export var state_name_shoot: String

@onready var pivot := $Pivot
@onready var right_handslot := $Pivot/Rig_Medium/Skeleton3D/Mage_HandslotRight/Marker3D

var FireballScene = preload("res://scenes/characters/mage/mage.tscn")

var _movement_blend := 0.0
var _dash_velocity: Vector3 = Vector3.ZERO

var _anim_state: AnimationState
var _lock: Lock
var queue: Queue
var _conditional_queue: ConditionalQueue
var _queue_processor: QueueProcessor

var anim: AnimationHandler
var blend: BlendHandler

# ----------- spells start ----------- #
func cast_fireball() -> void:
	var fireball = FireballScene.instantiate()
	get_tree().current_scene.add_child(fireball)

	fireball.global_position = right_handslot.global_position
	
	fireball.global_basis = pivot.global_basis
	fireball.global_basis = fireball.global_basis.rotated(Vector3.UP, PI)
	fireball.global_basis.z.y = 0

# -----------  spells end  ----------- #

func _ready() -> void:
	_anim_state = AnimationState.new(
		state_name_jump_idle,
		state_name_jump,
		state_name_land,
		state_name_shoot,
		state_name_dash,
	)
	_lock = Lock.new()
	queue = Queue.new()
	_conditional_queue = ConditionalQueue.new()
	_queue_processor = QueueProcessor.new(
		self, 
		queue, 
		_conditional_queue, 
		_anim_state, 
		jump_velocity
	)
	
	anim = AnimationFactory.create_animation_handler(anim_tree, path_playback_full_body, path_playback_right_arm)
	blend = AnimationFactory.create_blend_handler(
		self, 
		anim_tree, 
		path_full_body_locomotion_blend,
		path_full_body_dash_blend,
		path_right_arm_blend,
	)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		anim.play_full_body(state_name_jump)
	
	if Input.is_action_just_pressed("attack"):
		if not _lock.is_locked(Lock.Chain.Attack):
			_lock.lock(Lock.Chain.Attack)
			
			blend.blend_right_arm(1.0, 0.075)
			anim.play_right_arm(state_name_shoot, AnimationUtil.Play.Start)
			
			var check = func() -> bool: 
				return anim.get_current_node(AnimationHandler.PlaybackRegion.Upperbody) != state_name_shoot
			
			var finish  = func():
				_lock.unlock(Lock.Chain.Attack)
				blend.blend_right_arm(0.0)
			
			_conditional_queue.queue(
				Queue.Conditional,
				Queue.Conditional.FinishAttack,
				check,
				finish,
			)
	
	if Input.is_action_just_pressed("dash"):
		blend.blend_dash(MageCharacterBak.BlendHandler.Dash.Forward)
		anim.play_full_body(_anim_state.dash)

func _process(delta: float) -> void:
	_queue_processor.process(delta)

func _physics_process(delta: float) -> void:
	_physics_process_gravity(delta)
	_physics_process_movement(delta)
	_queue_processor.physics_process(delta)
	
	move_and_slide()

func _physics_process_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _physics_process_movement(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = _calculate_movement_direction(input_dir)
	
	if direction:
		velocity.x = direction.x * max_speed
		velocity.z = direction.z * max_speed
		_look_at(direction, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, max_speed)
		velocity.z = move_toward(velocity.z, 0, max_speed)
	
	_dash_velocity = _dash_velocity.move_toward(Vector3.ZERO, dash_decay * delta * 10.0)
	
	velocity.x += _dash_velocity.x
	velocity.z += _dash_velocity.z
	
	var movement_blend_target = _get_speed() / max_speed
	_movement_blend = lerp(_movement_blend, movement_blend_target, delta * 10)
	blend.blend_loco(_movement_blend)

func _calculate_movement_direction(input_dir: Vector2) -> Vector3:
	if camera_node == null:
		return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var cam_forward = camera_node.global_transform.basis.z
	cam_forward.y = 0
	cam_forward = cam_forward.normalized()
	
	var cam_right = camera_node.global_transform.basis.x
	cam_right.y = 0
	cam_right = cam_right.normalized()
	
	var direction = (cam_right * input_dir.x) + (cam_forward * input_dir.y)
	if direction.length() > 0:
		direction = direction.normalized()
	
	return direction

# physic processing helper scaffold
func _physics_process_(_delta: float) -> void:
	pass

func _look_at(direction: Vector3, delta: float) -> void:
	var target_rotation = _direction_atan2(direction)
	pivot.rotation.y = lerp_angle(pivot.rotation.y, target_rotation, delta * look_at_weight)

func _direction_atan2(direction: Vector3) -> float:
	if reverse_axis:
		return atan2(-direction.x, -direction.z)
	return atan2(direction.x, direction.z)

func _get_speed() -> float:
	return Vector3(velocity.x, 0, velocity.z).length()


# ----------- animation utility start ----------- #
class AnimationHandler:
	var _full_body_playback: AnimationUtil.Playback
	var _right_arm_playback: AnimationUtil.Playback
	
	enum PlaybackRegion {
		Fullbody,
		Upperbody,
	}
	
	func _init(
		full_body_playback: AnimationUtil.Playback,
		right_arm_playback: AnimationUtil.Playback,
	) -> void:
		_full_body_playback = full_body_playback
		_right_arm_playback = right_arm_playback
	
	func play_full_body(to_node: StringName, mode: AnimationUtil.Play = AnimationUtil.Play.Travel) -> void:
		_play(_full_body_playback, to_node, mode)
	
	func play_right_arm(to_node: StringName, mode: AnimationUtil.Play = AnimationUtil.Play.Travel) -> void:
		_play(_right_arm_playback, to_node, mode)
	
	func _play(playback: AnimationUtil.Playback, to_node: StringName, mode: AnimationUtil.Play = AnimationUtil.Play.Travel):
		playback.play(to_node, mode)
	
	func get_current_node(of: PlaybackRegion):
		match of:
			PlaybackRegion.Fullbody:
				return _full_body_playback.get_current_node()
			PlaybackRegion.Upperbody:
				return _right_arm_playback.get_current_node()
		
		return null

class BlendHandler:
	var _mage: MageCharacterBak
	var _tree: AnimationTree
	var _paths: AnimationBlendPaths
	
	enum Dash {
		Forward,
		Back,
		Left,
		Right,
	}
	
	func _init(mage: MageCharacterBak, tree: AnimationTree, paths: AnimationBlendPaths) -> void:
		_mage = mage
		_tree = tree
		_paths = paths
	
	func blend_loco(value: float) -> void:
		_tree.set(_paths.locomotion_full_body, value)
	
	func blend_dash(direction: Dash) -> void:
		var value: Vector2
		match direction:
			Dash.Forward:
				value = Vector2(0, 1)
			Dash.Back:
				value = Vector2(0, -1)
			Dash.Left:
				value = Vector2(-1, 0)
			Dash.Right:
				value = Vector2(1, 0)
		_tree.set(_paths.dash_full_body, value)
	
	func blend_right_arm(value: float, duration = 0.1) -> void:
		var tween = _mage.create_tween()
		tween.tween_property(_tree, _paths.right_arm, value, duration)

class AnimationBlendPaths:
	var locomotion_full_body: String
	var dash_full_body: String
	var right_arm: String
	
	func _init(
		p_locomotion_full_body: String,
		p_dash_full_body: String,
		p_right_arm: String,
	) -> void:
		locomotion_full_body = p_locomotion_full_body
		dash_full_body = p_dash_full_body
		right_arm = p_right_arm

class AnimationState:
	var jump_idle: String
	var jump_start: String
	var jump_land: String
	var attack: String
	var dash: String
	
	func _init(
		p_jump_idle: String,
		p_jump_start: String,
		p_jump_land: String,
		p_attack: String,
		p_dash: String,
	) -> void:
		jump_idle = p_jump_idle
		jump_start = p_jump_start
		jump_land = p_jump_land
		attack = p_attack
		dash = p_dash

class AnimationFactory:
	static func create_animation_handler(
		anim_tree: AnimationTree,
		path_playback_full_body: String,
		path_playback_right_arm: String,
	) -> AnimationHandler:
		var full_body_playback = anim_tree.get(path_playback_full_body)
		var right_arm_playback = anim_tree.get(path_playback_right_arm)
		var prefix = "[ERROR][AnimationFactory::create_animation_handler('%s', '%s')]" % [path_playback_full_body, path_playback_right_arm]
		
		assert(full_body_playback != null, "%s - full_body playback not found at '%s'" % [prefix, path_playback_full_body])
		assert(right_arm_playback != null, "%s - right_arm playback not found at '%s'" % [prefix, path_playback_right_arm])
		
		full_body_playback = AnimationUtil.Playback.new(full_body_playback)
		right_arm_playback = AnimationUtil.Playback.new(right_arm_playback)
		
		return AnimationHandler.new(full_body_playback, right_arm_playback)
	
	static func create_blend_handler(
		mage: MageCharacterBak,
		tree: AnimationTree,
		path_locomotion_full_body: String,
		path_full_body_dash_blend: String,
		path_right_arm_blend: String
	) -> BlendHandler:
		var paths = AnimationBlendPaths.new(
			path_locomotion_full_body,
			path_full_body_dash_blend,
			path_right_arm_blend,
		)
		return BlendHandler.new(mage, tree, paths)

# -----------  animation utility end  ----------- #

class QueueProcessor:
	var _queue: Queue
	var _conditional_queue: ConditionalQueue
	var _mage: MageCharacterBak
	var _state: MageCharacterBak.AnimationState
	var _jump_velocity: float
	
	var _falling: bool = false
	
	func _init(
		mage: MageCharacterBak, 
		queue: Queue,
		conditional_queue: ConditionalQueue,
		state: MageCharacterBak.AnimationState,
		jump_velocity: float,
	) -> void:
		_mage = mage
		_queue = queue
		_conditional_queue = conditional_queue
		_state = state
		_jump_velocity = jump_velocity
	
	func physics_process(delta: float) -> void:
		_process_jump(delta)
		_process_dash(delta)
	
	func process(delta: float) -> void:
		_conditional_queue.process(delta)
		_process_attack(delta)
	
	func _process_jump(_delta: float) -> void:
		if not _mage.is_on_floor():
			_queue.dequeue(Queue.Task.Jump)
			if not _falling:
				_falling = true
				_mage.anim.play_full_body(_state.jump_idle)
		
		elif _falling:
			_falling = false
			_mage.anim.play_full_body(_state.jump_land)
		
		if _mage.is_on_floor() and _queue.consume(Queue.Task.Jump):
			_mage.velocity.y = _jump_velocity
			_falling = true
	
	func _process_attack(_delta: float) -> void:
		if _queue.consume(Queue.Task.Attack):
			_mage.cast_fireball()
	
	func _process_dash(_delta: float) -> void:
		if not _queue.consume(Queue.Task.Dash):
			return
		
		var forward_vector = _mage.pivot.global_transform.basis.z
		forward_vector.y = 0
		forward_vector = forward_vector.normalized()
		
		_mage._dash_velocity = forward_vector * _mage.dash_power

class Queue extends RefCounted:
	enum Task {
		Jump,
		Attack,
		Dash,
	}

	enum Conditional {
		FinishAttack,
	}

	var _tasks: Array[Task] = []

	func queue(task: Task) -> void:
		if not _tasks.has(task):
			_tasks.append(task)

	func consume(task: Task) -> bool:
		if _tasks.has(task):
			_tasks.erase(task)
			return true
		return false

	func dequeue(task: Task) -> void:
		_tasks.erase(task)


class Lock extends RefCounted:
	enum Chain {
		Attack,
	}
	
	var _locks: Array[Chain] = []
	
	func lock(key: Chain) -> void:
		if not _locks.has(key):
			_locks.append(key)
	
	func unlock(key: Chain) -> void:
		if _locks.has(key):
			_locks.erase(key)
	
	func is_locked(key: Chain) -> bool:
		return _locks.has(key)
