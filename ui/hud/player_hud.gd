class_name PlayerHud extends CanvasLayer

@onready var health_bar := $MarginContainer/Control/StatContainer/Health
@onready var mana_bar := $MarginContainer/Control/StatContainer/Mana
@onready var stamina_bar := $MarginContainer/Control/StatContainer/Stamina

@onready var skill_1: TextureProgressBar = $MarginContainer/Control/VBoxContainer/SkillsContainer/Skill1
@onready var skill_2: TextureProgressBar = $MarginContainer/Control/VBoxContainer/SkillsContainer/Skill2
@onready var skill_3: TextureProgressBar = $MarginContainer/Control/VBoxContainer/SkillsContainer/Skill3
@onready var skill_progress := $MarginContainer/Control/VBoxContainer/CenterContainer/SkillProgres

func update_health(current: float, total: float, _delta: float) -> void:
	health_bar.value = current
	health_bar.max_value = total

func update_mana(current: float, total: float, _delta: float) -> void:
	mana_bar.value = current
	mana_bar.max_value = total

func update_stamina(current: float, total: float, _delta: float) -> void:
	stamina_bar.value = current
	stamina_bar.max_value = total

func update_skill_progress(current: float, total: float) -> void:
	skill_progress.value = current
	skill_progress.max_value = total

func show_skill_progress() -> void:
	skill_progress.visible = true

func hide_skill_progress() -> void:
	skill_progress.visible = false

func start_cooldown(action: StringName, cooldown: float) -> void:
	var progress
	match action:
		&"skill_1": progress = skill_1
		&"skill_2": progress = skill_2
		&"skill_3": progress = skill_3
	
	if progress != null:
		_start_cooldown(progress, cooldown)

func _start_cooldown(
	progress: TextureProgressBar,
	cooldown: float,
) -> void:
	progress.max_value = cooldown
	progress.value = cooldown
	
	var tween := progress.create_tween()
	tween.tween_property(progress, "value", 0.0, cooldown)
