class_name CharacterAbilityExecuteTriggerChanneledHandler extends CharacterAbilityExecuteTriggerHandler

var _data: CharacterAbilityTriggerChanneled

var _next_tick := 0.0

func setup(data: CharacterAbilityTrigger) -> void:
	_data = data
	_next_tick = 0.0

func start() -> void:
	if _is_released():
		return
	
	_handle_channeling_tick()

func tick(delta: float) -> void:
	if _is_released():
		return
	
	_handle_channeling_tick(delta)

func release() -> void:
	_emit_finished()

func _handle_channeling_tick(delta: float = 0.0) -> void:
	if _data.tick_rate <= 0.0:
		_emit_triggered_tick(0.0) # Todo: test and doublecheck behaviour. mana cost is calculated by multiply with time, so make sure its not multiplied by 0.0, therefore free
		return
	
	_next_tick -= delta
	
	while _next_tick <= 0.0:
		_next_tick += _data.tick_rate
		_emit_triggered_tick(_data.tick_rate)

func _is_released() -> bool:
	if _blackboard.is_released:
		_emit_finished()
		return true
	return false
