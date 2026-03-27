extends Node

const LABEL_GAME_OVER = "Game Over!"

@export var mage: MageCharacter
@export var hud: PlayerHud

func _ready() -> void:
	mage.died.connect(_on_player_died)
	mage.health_changed.connect(hud.update_health)
	mage.mana_changed.connect(hud.update_mana)
	mage.stamina_changed.connect(hud.update_stamina)
	
	mage.casting_started.connect(hud.show_skill_progress)
	mage.casting_end.connect(hud.hide_skill_progress)
	mage.casting_progressed.connect(hud.update_skill_progress)
	
	hud.skill_activated.connect(mage.use_skill)

func _on_player_died() -> void:
	GameUI.visible = true
	GameUI.change_label(LABEL_GAME_OVER)
