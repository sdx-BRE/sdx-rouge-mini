class_name SkeletonMinion extends CharacterBody3D

signal died()

@export_group("Skeleton properties")
@export var data: EnemyData

@export_group("Patrol settings")
@export var wait_time: float = 5.0
@export var patrol_points: Array[Marker3D]

@export_group("Animation - General")
@export var anim_tree: AnimationTree
@export var path_playback_full_body: String
@export var path_playback_upper_body: String
@export var path_full_body_locomotion_blend: String
@export var path_upper_body_blend2: String

@export_group("Animation - State names")
@export var state_full_body_death: String
@export var state_upper_body_idle: String
@export var state_upper_body_unarmed_idle: String
@export var state_upper_body_unarmed_punch: String
@export var state_upper_body_unarmed_kick: String

@export_group("Animation - Oneshot")
@export var path_oneshot_hit_weak: String
@export var path_oneshot_hit_strong: String
@export var path_oneshot_spawn_air: String
@export var path_oneshot_spawn_ground: String

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
		wait_time,
	)
	
	anim = SkeletonMinionAnimator.Builder.new(self, anim_tree)\
		.set_playbacks(path_playback_full_body, path_playback_upper_body)\
		.set_paths(path_full_body_locomotion_blend, path_upper_body_blend2)\
		.set_state_names(state_full_body_death, state_upper_body_idle, state_upper_body_unarmed_idle, state_upper_body_unarmed_punch, state_upper_body_unarmed_kick)\
		.set_oneshots(path_oneshot_hit_weak, path_oneshot_hit_strong, path_oneshot_spawn_air, path_oneshot_spawn_ground)\
		.build()
	
	processor = Processor.create(self, anim.blender)
	stats = EnemyStats.from_data(data)
	
	if ui is EnemyUI:
		stats.health_changed.connect(ui.update_health)
	stats.hp_reached_zero.connect(on_die)
	
	fov.body_entered.connect(_on_fov_entered)
	fov.body_exited.connect(_on_fov_exited)
	
	punch_hitbox.body_entered.connect(_on_punch)

func _on_punch(body: Node3D):
	print("punched: ", body)
	pass

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
	
	var death_anim_name = "%s_A" % state_full_body_death
	anim.play_full_body(death_anim_name)

func on_death_anim_finished(anim_name: StringName) -> void:
	var death_anim_name = "%s_A" % state_full_body_death
	if anim_name == death_anim_name:
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
		var _blender: SkeletonMinionAnimator.Blender
		var _movement_blend := 0.0
		
		func _init(minion: SkeletonMinion, blender: SkeletonMinionAnimator.Blender) -> void:
			super(minion)
			_blender = blender
		
		func process(delta: float) -> void:
			var movement_blend_target = _get_speed() / _minion.data.running_speed
			_movement_blend = lerp(_movement_blend, movement_blend_target, delta * 10)
			_blender.blend_loco(_movement_blend)
		
		func _get_speed() -> float:
			return Vector3(_minion.velocity.x, 0, _minion.velocity.z).length()
#endregion
