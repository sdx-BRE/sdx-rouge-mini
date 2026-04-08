class_name WaveSpawner extends Node3D

enum Mode {
	Circle,
	AtPositions,
}

@export_group("Wave Settings")
@export var mode: Mode = Mode.Circle
@export var enemy_scene: PackedScene
@export var enemies_per_wave: int = 5
@export var spawn_interval: float = 1.5
@export var spawn_container: Node3D

@export_group("Enemy configuration")
@export var patrol_points: Array[Marker3D]

@export_group("Mode Circle")
@export var spawn_point: Marker3D
@export var spawn_radius: float = 5.0

@export_group("Mode At Positions")
@export var positions: Array[Marker3D]

var _enemies_alive: int = 0
var _spawned_this_wave: int = 0
var _is_spawning: bool = false
var _spawn_timer: Timer

var _spawner: WaveSpawnBase

func _ready() -> void:
	if _check_exports():
		match mode:
			Mode.Circle:
				_spawner = WaveSpawnCircle.new(spawn_point, spawn_radius)
			Mode.AtPositions:
				_spawner = WaveSpawnAtPositions.new(positions)
	
	_spawn_timer = Timer.new()
	_spawn_timer.wait_time = spawn_interval
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(_spawn_timer)
	
	check_and_start_wave()

func _process(_delta: float) -> void:
	check_and_start_wave()

func check_and_start_wave() -> void:
	if not _is_spawning and _enemies_alive <= 0:
		_is_spawning = true
		_spawned_this_wave = 0
		_spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	var enemy := _create_enemy_node()
	_spawner.place_enemy(enemy)
	_enemies_alive += 1
	
	var patrol := patrol_points.duplicate()
	patrol.shuffle()
	
	enemy.patrol_points = patrol
	enemy.tree_exited.connect(_on_enemy_died)
	
	_spawned_this_wave += 1
	if _spawned_this_wave >= enemies_per_wave:
		_spawn_timer.stop()
		_is_spawning = false

func _create_enemy_node() -> Node3D:
	var enemy := enemy_scene.instantiate()
	enemy.patrol_points = patrol_points
	
	spawn_container.add_child(enemy)
	return enemy

func _on_enemy_died() -> void:
	_enemies_alive -= 1

func _check_exports() -> bool:
	var is_valid := true
	if not _is_valid_exports():
		is_valid = false
	
	match mode:
		Mode.Circle:
			is_valid = is_valid and _is_valid_circle_export()
		Mode.AtPositions:
			is_valid = is_valid and _is_valid_positions_export()
	
	return is_valid

func _is_valid_exports() -> bool:
	var err := []
	
	if enemy_scene == null:
		err.append("required: enemy_scene (PackedScene)")
	
	if spawn_interval == null:
		err.append("required: spawn_interval (Node3D)")
	
	if patrol_points == null or patrol_points.size() == 0:
		err.append("required: patrol_points (Array[Marker3D]) and MUST be not empty")
	
	if err.size() != 0:
		var separator := "\n\t"
		var msg := "\nInvalid properties:%s%s" % [separator, separator.join(err)]
		push_error(msg)
	
	return err.size() == 0

func _is_valid_circle_export() -> bool:
	if spawn_point == null:
		push_error("\nInvalid circle properties:\n\trequired: spawn_point (Node3D)")
		return false
	return true

func _is_valid_positions_export() -> bool:
	if positions == null:
		push_error("\nInvalid positions properties:\n\required: positions (Array[Marker3D]) and MUST be not empty")
		return false
	return true
