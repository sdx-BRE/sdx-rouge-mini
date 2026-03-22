class_name WaveSpawner extends Node

@export var max_enemies: int = 20
@export var spawn_duration: float = 5.0
@export var spawn_locations: Array[Marker3D]
@export var spawn_radius: float = 5.0
@export var respawn_timeout: float = 3.0
@export var skeleton_minion_scene: PackedScene

var _spawn_location_idx := 0
var _enemy_count := 0

var _state: State

#region lifecycle
func _ready() -> void:
	var emitter = PacedEmitter.new(max_enemies, spawn_duration)
	emitter.restart()
	emitter.tick_triggered.connect(func(_i): _spawn_minion())
	
	_state = State.create(emitter, respawn_timeout)

func _process(delta: float) -> void:
	_state.process(delta, _enemy_count)
#endregion

#region event listener
func _on_enemy_died() -> void:
	_enemy_count = max(_enemy_count - 1, 0)
#endregion

#region spawning
func _spawn_minion():
	var spawn_position = _get_spawn_position()
	var minion: SkeletonMinion = _init_minion()
	add_child(minion)
	
	minion.global_position = spawn_position
	minion.anim.oneshot_spawn_ground()
	
	minion.died.connect(_on_enemy_died)
	
	_enemy_count += 1

func _init_minion() -> SkeletonMinion:
	return skeleton_minion_scene.instantiate() as SkeletonMinion
#endregion

#region spawn position/location
func _get_spawn_position():
	var spawn_location = spawn_locations[_spawn_location_idx]
	return _get_random_pos_in_radius(spawn_location, spawn_radius)

func _next_spawn_location() -> void:
	if _spawn_location_idx >= spawn_locations.size():
		_spawn_location_idx = 0
	else:
		_spawn_location_idx += 1

func _get_random_pos_in_radius(marker: Marker3D, radius: float) -> Vector3:
	var angle = randf() * TAU
	var r = radius * sqrt(randf())
	var x = r * cos(angle)
	var z = r * sin(angle)
	
	return marker.global_position + Vector3(x, 0, z)
#endregion

#region FSM
class State:
	var _state: Base
	var _registry: Registry
	var _data: Data
	
	enum Kind {
		Spawning,
		Observing,
	}
	
	func _init(state: Base, registry: Registry, data: Data) -> void:
		_state = state
		_registry = registry
		_data = data
	
	static func create(emitter: PacedEmitter, respawn_timeout: float, start: Kind = Kind.Spawning) -> State:
		var spawning = Spawning.new(emitter)
		var observing = Observing.new(respawn_timeout)
		var registry = Registry.new(spawning, observing)
		var data = Data.new()
		
		if start == Kind.Observing:
			return State.new(observing, registry, data)
		return State.new(spawning, registry, data)
	
	func process(delta: float, enemy_count: int) -> void:
		var new_state = _state.process(delta, _data, _registry)
		if new_state != null:
			_state = new_state
			_state.enter(_data)
		
		_data.enemy_count = enemy_count
	
	class Registry:
		var spawning: State.Spawning
		var observing: State.Observing
		
		func _init(
			p_spawning: State.Spawning,
			p_observing: State.Observing,
		) -> void:
			spawning = p_spawning
			observing = p_observing
	
	class Data:
		var enemy_count: int = 0
	
	class Base:
		func process(_delta: float, _data: Data, _registry: Registry) -> Base: return null
		func enter(_data: Data) -> void: pass
	
	class Observing extends Base:
		var _respawn_timeout: float
		var _timeout: float
		
		func _init(respawn_timeout: float) -> void:
			_respawn_timeout = respawn_timeout
			_timeout = respawn_timeout
		
		func process(delta: float, data: Data, registry: Registry) -> Base:
			if data.enemy_count > 0:
				return null
			
			_timeout -= delta
			if _timeout < 0:
				return registry.spawning
			
			return null
		
		func enter(_data: Data) -> void: _timeout = _respawn_timeout
	
	class Spawning extends Base:
		var _emitter: PacedEmitter
		var _finished_emitting: bool = false
		
		func _init(emitter: PacedEmitter) -> void:
			_emitter = emitter
			_emitter.sequence_finished.connect(func(): _finished_emitting = true)
		
		func process(delta: float, _data: Data, registry: Registry):
			_emitter.process(delta)
			
			if _finished_emitting:
				return registry.observing
			
			return null
		
		func enter(_data: Data) -> void:
			_finished_emitting = false
			_emitter.restart()
#endregion

#region editor/@tool helper methods
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	
	if spawn_locations.is_empty():
		warnings.append("Spawn locations must be set!")
	if not _is_scene_type(skeleton_minion_scene, SkeletonMinion):
		warnings.append("Skeleton minion scene must be res://entities/enemies/skeleton_minion/SkeletonMinion.tscn")
	
	return warnings

func _is_scene_type(scene: PackedScene, type: GDScript) -> bool:
	if scene == null:
		return false
	
	var state = scene.get_state()
	for i in state.get_node_property_count(0):
		var prop_name = state.get_node_property_name(0, i)
		if prop_name == "script":
			var prop_value = state.get_node_property_value(0, i)
			if prop_value == type:
				return true
	
	return false
#endregion
