class_name PlayerHud extends CanvasLayer

@onready var health_bar := $MarginContainer/Control/StatContainer/Health
@onready var mana_bar := $MarginContainer/Control/StatContainer/Mana
@onready var stamina_bar := $MarginContainer/Control/StatContainer/Stamina

@onready var skill_1 := $MarginContainer/Control/VBoxContainer/SkillsContainer/Skill1
@onready var skill_2 := $MarginContainer/Control/VBoxContainer/SkillsContainer/Skill2
@onready var skill_3 := $MarginContainer/Control/VBoxContainer/SkillsContainer/Skill3
@onready var skill_progress := $MarginContainer/Control/VBoxContainer/CenterContainer/SkillProgres

func emulate_press_skill_1() -> void:
	_toggle_btn(skill_1)

func emulate_press_skill_2() -> void:
	_toggle_btn(skill_2)

func emulate_press_skill_3() -> void:
	_toggle_btn(skill_3)

func _toggle_btn(btn: Button, duration: float = 0.075) -> void:
	btn.toggle_mode = true
	btn.set_pressed_no_signal(true)
	await get_tree().create_timer(duration).timeout
	btn.set_pressed_no_signal(false)

func update_health(current: float, total: float) -> void:
	health_bar.value = current
	health_bar.max_value = total

func update_mana(current: float, total: float) -> void:
	mana_bar.value = current
	mana_bar.max_value = total

func update_stamina(current: float, total: float) -> void:
	stamina_bar.value = current
	stamina_bar.max_value = total

func update_skill_progress(current: float, total: float) -> void:
	skill_progress.value = current
	skill_progress.max_value = total

func show_skill_progress() -> void:
	skill_progress.visible = true

func hide_skill_progress() -> void:
	skill_progress.visible = false
