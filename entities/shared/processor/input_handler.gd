class_name InputHandler

func handle_input(event: InputEvent, viewport: Viewport) -> void:
	push_error("[Error][InputHandler]: handle_input() must be overwritten by child implementations, event: ", event, " - viewport: ", viewport)
