class_name SkeletonMinion extends CharacterBody3D

signal died()

@export_group("Skeleton properties")
@export var data: EnemyData
@export var punch_dmg: float = 5.0
@export var kick_dmg: float = 8.0

@export_group("Patrol settings")
@export var wait_time: float = 5.0
@export var patrol_points: Array[Marker3D]

@export_group("Animation - General")
@export var anim_tree: AnimationTree
@export var path_playback_full_body: String
@export var path_locomotion_blend: String
@export var path_locomotion_timescale: String

@export_group("Animation - State names")
@export var state_death: String

@export_group("Animation - Oneshot")
@export var oneshot_hit_weak: String
@export var oneshot_hit_strong: String
@export var oneshot_spawn_air: String
@export var oneshot_spawn_ground: String
@export var oneshot_punch: String
@export var oneshot_kick: String

@export_group("Animation - Thresholds")
@export var threshold_hit_strong: float = 12.5

@export_group("Field of view")
@export var fov_angle: float = 70:
	set(value):
		fov_angle = value
		fov_threshold = cos(deg_to_rad(fov_angle / 2.0))

@onready var pivot: Node3D = $Pivot
@onready var agent: NavigationAgent3D = $NavigationAgent3D
@onready var ui: EnemyUI = $EnemyViewport
@onready var fov: Area3D = $Fov
@onready var punch_hitbox: Area3D = $Pivot/Rig_Medium/Skeleton3D/BoneHandslotR/Hitbox

@onready var player: AnimationPlayer = anim_tree.get_node(anim_tree.anim_player)

var state_machine: SkeletonMinionStateMachine
var anim: SkeletonMinionAnimator
var processor: Processor
var stats: EnemyStats

var fov_threshold = cos(deg_to_rad(fov_angle / 2.0))

func _ready() -> void:
	state_machine = SkeletonMinionStateMachine.start_walking(
		self,
		data.walking_speed,
		data.running_speed,
		wait_time,
	)
	
	anim = SkeletonMinionAnimator.Builder.new(self, anim_tree)\
		.set_playbacks(path_playback_full_body)\
		.set_paths(path_locomotion_blend, path_locomotion_timescale)\
		.set_state_names(state_death)\
		.set_oneshots(oneshot_hit_weak, oneshot_hit_strong, oneshot_spawn_air, oneshot_spawn_ground, oneshot_punch, oneshot_kick)\
		.build()
	
	processor = Processor.create(self, anim.blender)
	stats = EnemyStats.from_data(data)
	
	if ui is EnemyUI:
		stats.health_changed.connect(ui.update_health)
	stats.hp_reached_zero.connect(on_die)
	
	fov.area_entered.connect(_on_fov_entered)
	fov.area_exited.connect(_on_fov_exited)
	
	punch_hitbox.body_entered.connect(_on_punch)

func _on_punch(body: Node3D):
	if body.has_method("take_dmg"):
		body.take_dmg(punch_dmg)

func is_alive() -> bool:
	return stats.is_alive()

func take_dmg(value: float) -> void:
	stats.take_dmg(value)
	if not is_alive():
		return
	
	if value >= threshold_hit_strong:
		anim.oneshot_hit_strong()
	else:
		anim.oneshot_hit_weak()

#region event callbacks
func on_die() -> void:
	if not anim_tree.animation_finished.is_connected(on_death_anim_finished):
		anim_tree.animation_finished.connect(on_death_anim_finished)
	
	anim.play_full_body(state_death)

func on_death_anim_finished(anim_name: StringName) -> void:
	if anim_name == state_death:
		anim_tree.animation_finished.disconnect(on_death_anim_finished)
		await get_tree().create_timer(1.0).timeout
		died.emit()
		queue_free()

func _on_fov_entered(body: Node3D):
	state_machine.target_entered(body)

func _on_fov_exited(body: Node3D):
	state_machine.target_exited(body)
#endregion

func _process(delta: float) -> void:
	anim.process(delta)

func _physics_process(delta: float) -> void:
	processor.velicoty.process(delta)
	processor.blend.process(delta)
	move_and_slide()

class HasMinion extends RefCounted:
	var _minion: SkeletonMinion
		
	func _init(minion: SkeletonMinion) -> void:
		_minion = minion

#region processor
class Processor:
	var velicoty: Velocity
	var blend: Blend
	
	func _init(p_velicoty: Velocity, p_blend: Blend) -> void:
		velicoty = p_velicoty
		blend = p_blend
	
	static func create(minion: SkeletonMinion, blender: SkeletonMinionAnimator.Blender):
		var arg_velicoty = Velocity.new(minion)
		var arg_blend = Blend.new(minion, blender)
		
		return Processor.new(arg_velicoty, arg_blend)
	
	class Velocity extends HasMinion:
		func process(delta: float) -> void:
			_process_gravity(delta)
			_process_patrol(delta)
		
		func _process_gravity(delta: float) -> void:
			if not _minion.is_on_floor():
				_minion.velocity += _minion.get_gravity() * delta
		
		func _process_patrol(delta: float) -> void:
			_minion.state_machine.process(delta)
	
	class Blend extends HasMinion:
		const BASE_TIMESCALE = 1.0
		const MAX_TIMESCALE = 1.8
		
		var _blender: SkeletonMinionAnimator.Blender
		
		var _movement_blend := 0.0
		var _movement_timescale := 1.0
		
		func _init(minion: SkeletonMinion, blender: SkeletonMinionAnimator.Blender) -> void:
			super(minion)
			_blender = blender
		
		func process(delta: float) -> void:
			var speed = _get_speed()
			var movement_blend = speed / _minion.data.walking_speed
			
			var run_to_walk_ratio = clamp(
				(speed - _minion.data.walking_speed) / (_minion.data.running_speed - _minion.data.walking_speed),
				0,
				1
			)
			var movement_timescale = lerp(BASE_TIMESCALE, MAX_TIMESCALE, run_to_walk_ratio)
			
			_movement_blend = lerp(_movement_blend, movement_blend, delta * 10)
			_movement_timescale = lerp(_movement_timescale, movement_timescale, delta * 10)
			
			_blender.blend_loco_move(_movement_blend)
			_blender.blend_loco_timescale(_movement_timescale)
		
		func _get_speed() -> float:
			return Vector3(_minion.velocity.x, 0, _minion.velocity.z).length()
#endregion
