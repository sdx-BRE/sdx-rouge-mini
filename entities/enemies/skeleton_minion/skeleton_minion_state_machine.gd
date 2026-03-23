class_name SkeletonMinionStateMachine extends RefCounted

const ATTACK_RANGE := 1.53
const ATTACK_COOLDOWN := 3.0

var _state_handler: StateHandler
var _target_handler: TargetHandler
var _data: State.Data

func _init(handler: StateHandler, target_handler: TargetHandler, data: State.Data) -> void:
	_state_handler = handler
	_target_handler = target_handler
	_data = data

static func start_walking(
	minion: SkeletonMinion,
	walking_speed: float,
	running_speed: float,
	wait_time: float,
) -> SkeletonMinionStateMachine:
	var controller = SkeletonMinionController.new(minion)
	controller.init_patrol_point()
	
	var target_handler = TargetHandler.new(minion)
	
	var data = State.Data.new(
		minion,
		controller,
		target_handler,
		walking_speed,
		running_speed,
		wait_time,
		0
	)
	
	var walking_state = State.Alive.Walking.new(data)
	var waiting_state = State.Alive.Waiting.new(data)
	var aggro_state = State.Alive.Aggro.new(
		data,
		State.Alive.Aggro.Attacking.new(data),
		State.Alive.Aggro.Chasing.new(data),
	)
	
	var alive_state = State.Alive.new(walking_state, data)
	
	alive_state.add_state(State.Id.Walking, walking_state)
	alive_state.add_state(State.Id.Wating, waiting_state)
	alive_state.add_state(State.Id.Aggro, aggro_state)
	
	var alive_handler = StateHandler.Alive.new(alive_state)
	
	var dead_state = State.Dead.new(data)
	var dead_handler = StateHandler.Dead.new(minion, dead_state, alive_handler)
	
	var state_handler = StateHandler.new(dead_handler)
	
	return SkeletonMinionStateMachine.new(state_handler, target_handler, data)

var d = DbgHelper.new()
func process(delta: float) -> void:
	_state_handler.handle(delta)
	
	d.call_every(func():
		var node = _data.minion.fov.get_node("CollisionShape3D") as CollisionShape3D
		var shape = node.shape as SphereShape3D
		DbgHelper.visualize_fov(_data.minion, _data.minion.fov_threshold, 1.0, shape.radius)
	, 60)
	

func target_entered(target: Node3D) -> void:
	_target_handler.add_target(target)

func target_exited(target: Node3D) -> void:
	_target_handler.remove_target(target)

class TargetHandler:
	var _host: SkeletonMinion
	var _targets_in_range: Array[Node3D]
	var _target: Node3D
	
	func _init(host: Node3D) -> void:
		_host = host
	
	func add_target(target: Node3D) -> void:
		if not _targets_in_range.has(target):
			_targets_in_range.append(target)
	
	func remove_target(target: Node3D) -> void:
		if _targets_in_range.has(target):
			_targets_in_range.erase(target)
	
	func update_target() -> void:
		for target in _targets_in_range:
			if AiUtil.is_visible(target, _host, _host.fov_threshold):
				_target = target
				return
		
		_target = null
	
	func has_target() -> bool:
		return _target != null
	
	func get_target_position() -> Vector3:
		if _target != null:
			return _target.global_position
		
		return Vector3.ZERO
		
	func is_target_in_range() -> bool:
		if _target == null:
			return false
			
		var distance_sqrd = _host.pivot.global_position.distance_squared_to(_target.global_position)
		
		return distance_sqrd <= ATTACK_RANGE * ATTACK_RANGE

class State:
	class Data:
		var minion: SkeletonMinion
		var controller: SkeletonMinionController
		var target_handler: TargetHandler
		var wait_time: float
		var walking_speed: float
		var running_speed: float
		var attack_cooldown: float
		
		func _init(
			p_minion: SkeletonMinion,
			p_controller: SkeletonMinionController,
			p_target_handler: TargetHandler,
			p_walking_speed: float,
			p_running_speed: float,
			p_wait_time: float,
			p_attack_cooldown: float,
		) -> void:
			minion = p_minion
			controller = p_controller
			target_handler = p_target_handler
			walking_speed = p_walking_speed
			running_speed = p_running_speed
			wait_time = p_wait_time
			attack_cooldown = p_attack_cooldown
	
	class Base:
		func process(_delta: float) -> int: return Id.NoChange
		func enter() -> void: pass
	
	class BaseWithData extends Base:
		var _data: Data
		func _init(data: Data) -> void: _data = data
	
	enum Id {
		NoChange,
		Walking,
		Wating,
		Aggro,
	}
	
	class Alive:
		var _state: Base
		var _states: Dictionary[Id, Base]
		var _data: Data
		
		func _init(state: Base, data: Data) -> void:
			_state = state
			_data = data
		
		func add_state(id: Id, state: Base) -> void:
			_states[id] = state
		
		func process(delta: float) -> void:
			_data.attack_cooldown -= delta
			_check_aggro()
			
			var new_state_id = _state.process(delta)
			if new_state_id != Id.NoChange:
				_state = _states[new_state_id]
				_state.enter()
		
		func _check_aggro():
			_data.target_handler.update_target()
			if _data.target_handler.has_target() and _state != _states[Id.Aggro]:
				_state = _states[Id.Aggro]
				_state.enter()
				print("enter aggro (todo: remove)")
		
		class Walking extends BaseWithData:
			func process(delta: float) -> Id:
				if _data.minion.agent.is_navigation_finished():
					return Id.Wating
				
				_data.controller.move_towards_next_point(_data.walking_speed, delta)
				
				return Id.NoChange
		 
		class Waiting extends BaseWithData:
			var _wait_time: float
			
			func _init(data: Data) -> void:
				super(data)
				_wait_time = data.wait_time
			
			func process(delta: float) -> Id:
				_data.controller.brake_when_moving(_data.walking_speed)
				
				_wait_time -= delta
				if _wait_time <= 0:
					_data.controller.next_patrol_point()
					return Id.Walking
				return Id.NoChange
			
			func enter() -> void:
				_wait_time = _data.wait_time
		
		class Aggro extends BaseWithData:
			var _attacking: Attacking
			var _chasing: Chasing
			
			func _init(data: Data, attacking: Attacking, chasing: Chasing) -> void:
				super(data)
				_attacking = attacking
				_chasing = chasing
			
			func process(delta: float) -> Id:
				if not _data.target_handler.has_target():
					print("exit aggro (todo: remove)")
					return Id.Wating # Todo: Implement pushdown automata to return to last state
				
				if _data.target_handler.is_target_in_range(): _attacking.process(delta)
				else: _chasing.process(delta)
				
				return Id.NoChange
			
			class Attacking extends BaseWithData:
				func process(_delta: float):
					_data.controller.brake_when_moving(_data.walking_speed)
					
					if not _data.minion.anim.is_attacking and _data.attack_cooldown <= 0:
						_data.minion.anim.punch_attack()
						_data.attack_cooldown = ATTACK_COOLDOWN
			
			class Chasing extends BaseWithData:
				var _last_enemy_pos: Vector3 = Vector3.ZERO
				
				func process(delta: float):
					var target_pos = _data.target_handler.get_target_position()
					if _last_enemy_pos != target_pos:
						_last_enemy_pos = target_pos
						_data.controller.change_target(target_pos)
					
					_data.controller.move_towards_next_point(_data.running_speed, delta)
	
	class Dead extends Base:
		var _data: Data
		
		func _init(data: Data) -> void:
			_data = data
		
		func process(_delta: float) -> Id:
			if _data.minion.velocity.length() > 0:
				_data.minion.velocity = Vector3.ZERO
			return Id.NoChange

class StateHandler:
	var _root: BaseHandler
	
	func _init(root: BaseHandler) -> void:
		_root = root
	
	func handle(delta: float) -> void:
		_root.handle(delta)
	
	class BaseHandler:
		func handle(_delta: float) -> void: push_error("[SkeletonMinionStateMachine::StateHandler::BaseHandler.handle()] - must be overriden!")
	
	class Alive extends BaseHandler:
		var _state: State.Alive
		
		func _init(state: State.Alive) -> void:
			_state = state
		
		func handle(delta: float) -> void:
			_state.process(delta)
	
	class Dead extends BaseHandler:
		var _minion: SkeletonMinion
		var _state: State.Dead
		var _next: Alive
		
		func _init(minion: SkeletonMinion, state: State.Dead, next: Alive) -> void:
			_minion = minion
			_state = state
			_next = next
		
		func handle(delta: float):
			if _minion.is_alive():
				_next.handle(delta)
				return
			_state.process(delta)

class SkeletonMinionController:
	var _minion: SkeletonMinion
	var _patrol_point_size: int
	var _patrol_index = 0
	
	func _init(minion: SkeletonMinion) -> void:
		_minion = minion
		_patrol_point_size = minion.patrol_points.size()
	
	func change_target(target: Vector3) -> void:
		_minion.agent.target_position = target
	
	func move_towards_next_point(speed: float, delta: float) -> void:
		var next_pos = _minion.agent.get_next_path_position()
		var dir = (next_pos - _minion.global_position)
		dir.y = 0
		dir = dir.normalized()
		
		if not dir.is_zero_approx():
			look_at(dir, delta)
		
		_minion.velocity = dir * speed
	
	func brake(friction: float) -> void:
		_minion.velocity.x = move_toward(_minion.velocity.x, 0, friction)
		_minion.velocity.z = move_toward(_minion.velocity.z, 0, friction)
	
	func brake_when_moving(friction: float) -> void:
		if _minion.velocity.length() > 0:
			brake(friction)
	
	func next_patrol_point():
		if _patrol_index + 1 >= _patrol_point_size:
			_patrol_index = 0
		else:
			_patrol_index += 1
		
		use_patrol_point_as_target()
	
	func use_patrol_point_as_target() -> void:
		if _patrol_point_size == 0:
			return
		var patrol_point = _minion.patrol_points[_patrol_index]
		change_target(patrol_point.global_position)
	
	func init_patrol_point() -> void:
		if _patrol_point_size == 0:
			return
	
		_patrol_index = 0
		var patrol_point = _minion.patrol_points[_patrol_index]
		_minion.agent.target_position = patrol_point.global_position
	
	func look_at(direction: Vector3, delta: float) -> void:
		var target_rotation = atan2(-direction.x, -direction.z)
		_minion.rotation.y = lerp_angle(_minion.rotation.y, target_rotation, delta * 10.5)
