class_name MageCharacter extends CharacterBody3D

signal died()
signal dying()

signal health_changed(current: float, total: float)
signal mana_changed(current: float, total: float)
signal stamina_changed(current: float, total: float)

signal casting_started()
signal casting_end()
signal casting_progressed(current: float, total: float)

signal skill_cooldown(action: StringName, cooldown: float)

@export var data: MageData
@export var look_at_weight := 10.0
@export var spawn_container: Node3D

#@export var dev_ability_projectile: NCharacterAbilityData;
#@export var dev_ability_aoe: NCharacterAbilityData;
#@export var dev_ability_sprint: NCharacterAbilityData;
#@export var dev_ability_dash: NCharacterAbilityData;
#@export var dev_ability_jump: NCharacterAbilityData;

@export var dev_firepulse: MCharacterAbilityData;
@export var dev_firebolt: MCharacterAbilityData;
@export var dev_spellshield: MCharacterAbilityData;
@export var dev_meteor: MCharacterAbilityData;
@export var dev_sprint: MCharacterAbilityData;
@export var dev_jump: MCharacterAbilityData;
@export var dev_dash: MCharacterAbilityData;

@export var dev_abilities: Array[MCharacterAbilityData]

@export_group("Abilities")
@export var abilities: Array[CharacterAbilityData]

@export_group("Camera")
@export var camera_node: ThirdPersonCam

@export_group("AnimationTree - Parameters")
@export var anim_tree: AnimationTree
@export var param_playback_full_body: StringName
@export var param_blend_locomotion: StringName
@export var param_state_death: AnimStateMap
@export var oneshot_hit_weak: StringName
@export var oneshot_hit_strong: StringName
@export var animation_jump_land: StringName

@export_group("Animation - Thresholds")
@export var threshold_hit_strong: float = 12.5

@onready var pivot := $Pivot
@onready var buff_anchor := $BuffAnchor
@onready var wandspawn_node := $Pivot/Rig_Medium/Skeleton3D/Mage_HandslotRight/Mage_WeaponContainerRight/Mage_Wand/Mage_WandSpawn
@onready var ground_target_marker := $GroundTargetMarker
@onready var enemy_target_marker := $EnemyTargetMarker
@onready var target_point := $TargetPoint

var _stats: EntityStats
var _anim: MageAnimator
var _ability_system: CharacterAbilitySystem
var _m_ability_system: MCharacterAbilitySystem
var _processor: EntityProcessor

func _ready() -> void:
	var signals := MageSignals.new(
		died,
		dying,
		health_changed,
		mana_changed,
		stamina_changed,
		casting_started,
		casting_end,
		casting_progressed,
		skill_cooldown,
	)
	MageBootstrapper.bootstrap(self, signals)

func _on_dying() -> void:
	dying.emit()
	_anim.die()
	
	$DamageHitbox.collision_layer = 0
	$DamageHitbox.collision_mask = 0
	_disable_processing()
#endregion

#region lifecycle methods
func _process(delta: float) -> void:
	_processor.process(delta)

func _unhandled_input(event: InputEvent) -> void:
	_processor.handle_unhandled_input(event)

func _physics_process(delta: float) -> void:
	_processor.physics_process(delta)
#endregion

func take_dmg(value: float) -> void:
	_stats.take_dmg(value)
	
	if value >= threshold_hit_strong:
		_anim.hit_strong()
	else:
		_anim.hit_weak()

func execute_cast() -> void:
	#_ability_system.execute_buffered_ability()
	_m_ability_system.notify_animation_event()

func _enable_processing() -> void: _set_processing(true)
func _disable_processing() -> void: _set_processing(false)

func _set_processing(to: bool) -> void:
	set_process(to)
	set_physics_process(to)
	set_process_unhandled_input(to)

func get_target_point() -> Marker3D:
	return target_point
