class_name RestartMenu extends CanvasLayer

signal restart()

@onready var button := $Panel/CenterContainer/RestartButton

func _ready() -> void:
	button.pressed.connect(restart.emit)
	visibility_changed.connect(_on_visibility_changed)

func _unhandled_input(_event: InputEvent) -> void:
	if visible: get_viewport().set_input_as_handled()

func _on_visibility_changed() -> void:
	if visible: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
