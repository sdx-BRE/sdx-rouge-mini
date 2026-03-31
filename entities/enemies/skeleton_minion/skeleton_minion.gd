class_name SkeletonMinion extends CharacterBody3D

const ATTACK_RANGE := 1.53

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
@export var fov_angle: float = 70

@onready var agent: NavigationAgent3D = $NavigationAgent3D
@onready var ui: EnemyUI = $EnemyViewport
@onready var fov: Area3D = $Fov
@onready var punch_hitbox: Area3D = $Pivot/Rig_Medium/Skeleton3D/BoneHandslotR/Hitbox
@onready var target_point := $TargetPoint

@onready var player: AnimationPlayer = anim_tree.get_node(anim_tree.anim_player)

var _processor: EntityProcessor
var _stats: EnemyStats
var _anim: SkeletonMinionAnimator
var _target_handler: AiTargetHandler

func _ready() -> void:
	SkeletonMinionBootstrapper.bootstrap(self)

func is_alive() -> bool:
	return _stats.is_alive()

func take_dmg(value: float) -> void:
	_stats.take_dmg(value)
	if not is_alive():
		return
	
	if value >= threshold_hit_strong:
		_anim.hit_strong()
	else:
		_anim.hit_weak()

func get_target_point() -> Marker3D:
	return target_point

#region event callbacks
func _on_punch(body: Node3D) -> void:
	if body.has_method("take_dmg"):
		body.take_dmg(punch_dmg)

func on_die() -> void:
	if not anim_tree.animation_finished.is_connected(on_death_anim_finished):
		anim_tree.animation_finished.connect(on_death_anim_finished)
	
	_anim.die()
	set_physics_process(false)
	set_process(false)

func on_death_anim_finished(anim_name: StringName) -> void:
	if anim_name == state_death:
		anim_tree.animation_finished.disconnect(on_death_anim_finished)
		await get_tree().create_timer(1.0).timeout
		died.emit()
		queue_free()

func _on_fov_entered(body: Node3D):
	_target_handler.add_target(body)

func _on_fov_exited(body: Node3D):
	_target_handler.remove_target(body)
#endregion

func _process(delta: float) -> void:
	_processor.process(delta)

func _physics_process(delta: float) -> void:
	_processor.physics_process(delta)
