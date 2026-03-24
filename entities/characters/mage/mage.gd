class_name MageCharacter extends CharacterBody3D

signal health_changed(current: float, total: float)
signal mana_changed(current: float, total: float)
signal stamina_changed(current: float, total: float)
signal casting_started()
signal casting_end()
signal casting_progressed(current: float, total: float)

@export_group("Player properties")
@export var max_speed := 5.0
@export var look_at_weight := 10.0
@export var dash_power := 20.0
@export var dash_decay := 8.0

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

@onready var pivot := $Pivot
@onready var wandspawn_node := $Pivot/Rig_Medium/Skeleton3D/Mage_HandslotRight/Mage_WeaponContainerRight/Mage_Wand/Mage_WandSpawn
@onready var aim_decal := $AimTarget

var stats: Stats

var anim: MageAnimator
var controller: MageController
var processor: MageProcessor

var abilities: MageAbilityHandler

func _ready() -> void:
	stats = Stats.new(self)
	
	anim = MageAnimator.create(
		anim_tree,
		param_playback_full_body,
		param_blend_locomotion,
	)
	controller = MageController.create(self, self.camera_node, max_speed, dash_decay)
	abilities = MageAbilityHandlerFactory.create(self, controller)
	processor = MageProcessor.new(controller, anim, abilities, get_viewport())

#region stat notification
func notify_health_changed(current: float, total: float) -> void:
	health_changed.emit(current, total)

func notify_mana_changed(current: float, total: float) -> void:
	mana_changed.emit(current, total)

func notify_stamina_changed(current: float, total: float) -> void:
	stamina_changed.emit(current, total)

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

class Stats extends RefCounted:
	var _mage: MageCharacter
		
	func _init(mage: MageCharacter) -> void:
		_mage = mage
	
	var _max_health := 100.0
	var _max_mana := 100.0
	var _max_stamina := 100.0
	
	var _health := _max_health
	var _mana := _max_mana
	var _stamina := _max_stamina
	
	func take_dmg(value: float) -> void:
		_health = max(_health - value, 0)
		_mage.notify_health_changed(_health, _max_health)
	
	func heal(value: float) -> void:
		_health = min(_health + value, _max_health)
		_mage.notify_health_changed(_health, _max_health)
	
	func has_health() -> bool:
		return _health > 0
	
	func use_mana(value: float) -> void:
		_mana = max(_mana - value, 0)
		_mage.notify_mana_changed(_mana, _max_mana)
	
	func has_mana() -> bool:
		return _mana > 0
	
	func restore_mana(value: float) -> void:
		_mana = min(_mana + value, _max_mana)
		_mage.notify_mana_changed(_mana, _max_mana)
	
	func use_stamina(value: float) -> void:
		_stamina = max(_stamina - value, 0)
		_mage.notify_stamina_changed(_stamina, _max_stamina)
	
	func has_stamina() -> bool:
		return _stamina > 0
	
	func restore_stamina(value: float) -> void:
		_stamina = min(_stamina + value, _max_stamina)
		_mage.notify_stamina_changed(_stamina, _max_stamina)
