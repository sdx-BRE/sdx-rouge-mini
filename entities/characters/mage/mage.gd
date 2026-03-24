class_name MageCharacter extends CharacterBody3D

signal health_changed(current: float, total: float)
signal mana_changed(current: float, total: float)
signal stamina_changed(current: float, total: float)
signal casting_started()
signal casting_end()
signal casting_progressed(current: float, total: float)

@export var data: MageData
@export var look_at_weight := 10.0

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

@export_group("Animation - data")
@export var animation_shoot: SpellAnimationData
@export var animation_raise: SpellAnimationData
@export var animation_dash: MageAnimationData

@onready var pivot := $Pivot
@onready var wandspawn_node := $Pivot/Rig_Medium/Skeleton3D/Mage_HandslotRight/Mage_WeaponContainerRight/Mage_Wand/Mage_WandSpawn
@onready var aim_decal := $AimTarget

var stats: MageStats
var anim: MageAnimator
var controller: MageController
var abilities: MageAbilityHandler
var resource_generator: MageResourceGenerator
var processor: MageProcessor

func _ready() -> void:
	stats = MageStats.from_data(data)
	
	stats.health_changed.connect(health_changed.emit)
	stats.mana_changed.connect(mana_changed.emit)
	stats.stamina_changed.connect(stamina_changed.emit)
	
	anim = MageAnimator.create(
		anim_tree,
		param_playback_full_body,
		param_blend_locomotion,
	)
	controller = MageController.create(self, self.camera_node, data.max_speed, data.dash_decay, look_at_weight)
	abilities = MageAbilityHandlerFactory.create(self, controller)
	resource_generator = MageResourceGenerator.new(stats, data.mana_regeneration, data.stamina_regeneration)
	processor = MageProcessor.new(controller, anim, abilities, resource_generator, get_viewport())

#region stat notification
func notify_casting_started() -> void:
	casting_started.emit()

func notify_casting_end() -> void:
	casting_end.emit()

func notify_casting_progressed(current: float, total: float) -> void:
	casting_progressed.emit(current, total)
#endregion

#region lifecycle methods
func _process(delta: float) -> void:
	processor.process(delta)

func _unhandled_input(event: InputEvent) -> void:
	processor.handle_unhandled_input(event)

func _physics_process(delta: float) -> void:
	processor.physics_process(delta)
	move_and_slide()
#endregion
