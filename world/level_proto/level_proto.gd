extends Node

@export var mage: MageCharacter
@export var hud: PlayerHud

@export var skeleton_minion_scene: PackedScene
@export var skeleton_minion_patrol_points: Array[Marker3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mage.health_changed.connect(hud.update_health)
	mage.mana_changed.connect(hud.update_mana)
	mage.casting_started.connect(hud.show_skill_progress)
	mage.casting_end.connect(hud.hide_skill_progress)
	mage.casting_progressed.connect(hud.update_skill_progress)
	
	hud.skill_activated.connect(mage.processor.use_skill)
