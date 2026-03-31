class_name SkeletonIceMage extends CharacterBody3D

const ATTACK_RANGE := 15.0

signal died()

@export_group("Skeleton properties")
@export var data: EnemyData
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
@export var state_death: StringName

@export_group("Animation - Oneshot")
@export var oneshot_hit_weak: StringName
@export var oneshot_hit_strong: StringName
@export var oneshot_spawn_air: StringName
@export var oneshot_spawn_ground: StringName
@export var oneshot_shoot: StringName
@export var oneshot_raise: StringName

@export_group("Animation - Thresholds")
@export var threshold_hit_strong: float = 12.5

@export_group("Field of view")
@export var fov_angle: float = 70

@onready var agent: NavigationAgent3D = $NavigationAgent3D
@onready var ui: EnemyUI = $EnemyViewport
@onready var fov: Area3D = $Fov
@onready var target_point := $TargetPoint

var _anim: SkeletonIceMageAnimator
var _stats: EntityStats
var _processor: EntityProcessor
var _target_handler: AiTargetHandler

func _ready() -> void:
	SkeletonIceMageBootstrapper.bootstrap(self)

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

func _physics_process(delta: float) -> void:
	_processor.physics_process(delta)

func _process(delta: float) -> void:
	_processor.process(delta)

func execute_spell() -> void:
	DbgHelper.tprint("execute spell")

func take_dmg(value: float) -> void:
	_stats.take_dmg(value)
	if not _stats.is_alive():
		return
	
	if value >= threshold_hit_strong:
		_anim.hit_strong()
	else:
		_anim.hit_weak()

func _on_fov_entered(body: Node3D):
	_target_handler.add_target(body)

func _on_fov_exited(body: Node3D):
	_target_handler.remove_target(body)
