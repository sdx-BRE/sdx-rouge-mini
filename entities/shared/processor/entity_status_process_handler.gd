class_name EntityStatusProcessHandler extends ProcessHandler

var _status_manager: EntityStatusManager

func _init(status_manager: EntityStatusManager) -> void:
	_status_manager = status_manager

func process(delta: float) -> void:
	_status_manager.tick(delta)
