class_name EntityProcessor extends RefCounted

var _viewport: Viewport
var _physics_process_handlers: Array[PhysicsProcessHandler] = []
var _process_handlers: Array[ProcessHandler] = []
var _input_handlers: Array[InputHandler] = []

func _init(viewport: Viewport) -> void:
	_viewport = viewport

func add_physics_handler(handler: PhysicsProcessHandler) -> void:
	_physics_process_handlers.append(handler)

func add_process_handler(handler: ProcessHandler) -> void:
	_process_handlers.append(handler)

func add_input_handler(handler: InputHandler) -> void:
	_input_handlers.append(handler)

func physics_process(delta: float) -> void:
	for handler in _physics_process_handlers:
		handler.physics_process(delta)

func process(delta: float) -> void:
	for handler in _process_handlers:
		handler.process(delta)

func handle_unhandled_input(event: InputEvent) -> void:
	for handler in _input_handlers:
		if _viewport.is_input_handled():
			break
		handler.handle_input(event, _viewport)
