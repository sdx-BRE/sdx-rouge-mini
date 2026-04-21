class_name GameMenu extends CanvasLayer

@onready var restart_btn := $Panel/CenterContainer/VBoxContainer/RestartButton
@onready var menu_label := $Panel/CenterContainer/VBoxContainer/MenuLabel

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	restart_btn.pressed.connect(_on_restart_btn_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if visible: get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("ui_cancel"):
		GameUI.visible = !GameUI.visible
		get_tree().paused = GameUI.visible
		get_viewport().set_input_as_handled()
		change_label("Pause")

func change_label(label: StringName) -> void:
	menu_label.text = label

func _on_visibility_changed() -> void:
	if visible: CursorManager.set_visible_mode()
	else: CursorManager.set_captured_mode()

func _on_restart_btn_pressed() -> void:
	var tree = get_tree()
	
	visible = false
	tree.paused = false
	tree.reload_current_scene()
