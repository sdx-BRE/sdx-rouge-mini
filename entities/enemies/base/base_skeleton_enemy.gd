class_name BaseSkeletonEnemy extends CharacterBody3D

signal died()

@export var data: EnemyData
@export var anim_params: AnimationTreeParameter
@export var bootstrap_script: Script

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var pivot := $Pivot
@onready var agent: NavigationAgent3D = $NavigationAgent3D
@onready var ui: EnemyUI = $EnemyViewport
@onready var fov: Area3D = $Fov
@onready var target_point := $TargetPoint

var _stats: EntityStats
var _processor: EntityProcessor
var _target_handler: AiTargetHandler
var _anim: EnemyAnimation

func _ready() -> void:
	var bootstrapper: BaseSkeletonEnemyBootstrapper = bootstrap_script.new(self)
	if bootstrapper.has_method("setup"):
		bootstrapper.setup(self)
	
	bootstrapper.boot()

func _process(delta: float) -> void:
	_processor.process(delta)

func _physics_process(delta: float) -> void:
	_processor.physics_process(delta)

func take_damage(hit: DamageInstance) -> void:
	_stats.take_damage(hit)
	if not _stats.is_alive():
		return
	
	if hit.amount >= 12: # Todo: Fix hardcoded value
		_anim.hit_strong()
	else:
		_anim.hit_weak()

func get_target_point() -> Marker3D:
	return target_point

func on_die() -> void:
	if not anim_tree.animation_finished.is_connected(on_death_anim_finished):
		anim_tree.animation_finished.connect(on_death_anim_finished)
	
	_anim.die()
	set_physics_process(false)
	set_process(false)

func on_death_anim_finished(anim_name: StringName) -> void:
	if anim_name == anim_params.anim_name_death:
		anim_tree.animation_finished.disconnect(on_death_anim_finished)
		await get_tree().create_timer(1.0).timeout
		died.emit()
		queue_free()

func _on_fov_entered(body: Node3D):
	_target_handler.add_target(body)

func _on_fov_exited(body: Node3D):
	_target_handler.remove_target(body)
