class_name MageCharacter extends CharacterBody3D

signal died()
signal dying()

signal health_changed(current: float, total: float)
signal mana_changed(current: float, total: float)
signal stamina_changed(current: float, total: float)
signal casting_started()
signal casting_end()
signal casting_progressed(current: float, total: float)

@export var data: MageData
@export var look_at_weight := 10.0
@export var spawn_container: Node3D

@export_group("Spell resources")
@export var firebolt_data: SpellResource
@export var firepulse_data: SpellResource
@export var meteor_data: SpellResource

@export_group("Camera")
@export var camera_node: ThirdPersonCam

@export_group("AnimationTree - Parameters")
@export var anim_tree: AnimationTree
@export var param_playback_full_body: String
@export var param_blend_locomotion: String
@export var param_state_death: AnimStateMap

@export_group("Animation - data")
@export var animation_shoot: SpellAnimationData
@export var animation_raise: SpellAnimationData
@export var animation_dash: MageAnimationData
@export var animation_jump: MageAnimationData

@onready var pivot := $Pivot
@onready var wandspawn_node := $Pivot/Rig_Medium/Skeleton3D/Mage_HandslotRight/Mage_WeaponContainerRight/Mage_Wand/Mage_WandSpawn
@onready var aim_decal := $AimTarget

var _stats: MageStats
var _anim: MageAnimator
var _abilities: MageAbilityHandler
var _processor: MageProcessor

func _ready() -> void:
	_stats = MageStats.from_data(data)
	
	_stats.health_changed.connect(health_changed.emit)
	_stats.mana_changed.connect(mana_changed.emit)
	_stats.stamina_changed.connect(stamina_changed.emit)
	_stats.health_reached_zero.connect(_on_dying)
	
	_anim = MageAnimator.create(
		anim_tree,
		param_playback_full_body,
		param_blend_locomotion,
		param_state_death,
	)
	_anim.register_signals(died)
	
	var movement_config := MageMovementConfig.from_mage(self)
	var movement_motion := MageMovementMotion.from_mage(self)
	var kinematics := MageKinematics.new(self, movement_config, movement_motion)
	
	var controller := MageController.new(self, movement_config, movement_motion)
	_abilities = MageAbilityHandler.create(self, _anim, _stats, controller, casting_started, casting_progressed, casting_end)
	
	var resource_generator := MageResourceGenerator.new(_stats, data.mana_regeneration, data.stamina_regeneration)
	_processor = MageProcessor.new(kinematics, _anim, _abilities, resource_generator, get_viewport())

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

func use_skill(index: int) -> void:
	_processor.use_skill(index)

func execute_buffered_ability() -> void:
	_abilities.execute_buffered_ability()

func _enable_processing() -> void: _set_processing(true)
func _disable_processing() -> void: _set_processing(false)

func _set_processing(to: bool) -> void:
	set_process(to)
	set_physics_process(to)
	set_process_unhandled_input(to)
