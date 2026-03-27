class_name SkeletonMinion extends CharacterBody3D

signal died()

@export_group("Skeleton properties")
@export var data: EnemyData
@export var punch_dmg: float = 5.0
@export var kick_dmg: float = 8.0
@export var attack_cooldown: float = 3.0

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

var _processor: SkeletonMinionProcessor
var _stats: EnemyStats
var _anim: SkeletonMinionAnimator

var fov_threshold := cos(deg_to_rad(fov_angle / 2.0))

func _ready() -> void:
	_stats = EnemyStats.from_data(data)
	_anim = SkeletonMinionAnimator.Builder.new(self, anim_tree)\
		.set_playbacks(path_playback_full_body)\
		.set_paths(path_locomotion_blend, path_locomotion_timescale)\
		.set_state_names(state_death)\
		.set_oneshots(oneshot_hit_weak, oneshot_hit_strong, oneshot_spawn_air, oneshot_spawn_ground, oneshot_punch, oneshot_kick)\
		.build()
	
	var controller := SkeletonMinionController.new(self, agent, patrol_points)
	var state_machine := SkeletonMinionStateMachine.start_walking(
		SkeletonMinionStateContext.new(
			controller,
			SkeletonMinionStateMachineTargetHandler.new(self),
			_anim,
			SkeletonMinionStateData.from_minion(self),
			SkeletonMinionStateConfig.from_minion(self),
		),
		_stats,
	)
	
	var locomotion_handler := SkeletonMinionLocomotionHandler.new(controller, _anim, data.walking_speed, data.running_speed)
	_processor = SkeletonMinionProcessor.new(_anim, controller, state_machine, locomotion_handler)
	
	if ui is EnemyUI:
		_stats.health_changed.connect(ui.update_health)
	_stats.hp_reached_zero.connect(on_die)
	
	fov.area_entered.connect(_on_fov_entered)
	fov.area_exited.connect(_on_fov_exited)
	
	punch_hitbox.body_entered.connect(_on_punch)

func is_alive() -> bool:
	return _stats.is_alive()

func take_dmg(value: float) -> void:
	_stats.take_dmg(value)
	if not is_alive():
		return
	
	if value >= threshold_hit_strong:
		_anim.oneshot_hit_strong()
	else:
		_anim.oneshot_hit_weak()

#region event callbacks
func _on_punch(body: Node3D):
	if body.has_method("take_dmg"):
		body.take_dmg(punch_dmg)

func on_die() -> void:
	if not anim_tree.animation_finished.is_connected(on_death_anim_finished):
		anim_tree.animation_finished.connect(on_death_anim_finished)
	
	_anim.play_full_body(state_death)

func on_death_anim_finished(anim_name: StringName) -> void:
	if anim_name == state_death:
		anim_tree.animation_finished.disconnect(on_death_anim_finished)
		await get_tree().create_timer(1.0).timeout
		died.emit()
		queue_free()

func _on_fov_entered(body: Node3D):
	_processor.target_entered(body)

func _on_fov_exited(body: Node3D):
	_processor.target_exited(body)
#endregion

func _process(delta: float) -> void:
	_processor.process(delta)

func _physics_process(delta: float) -> void:
	_processor.physics_process(delta)
