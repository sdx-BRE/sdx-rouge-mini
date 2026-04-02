class_name PhasedAbilityHandler extends CharacterAbilityHandler

var _ability: CharacterPhasedAbility

var _active: CharacterPhasedAbility
var _buffered: CharacterPhasedAbility

func try_activate(state: CharacterAbilitySystem.TriggerState) -> void:
	if state != CharacterAbilitySystem.TriggerState.Press:
		return
	
	if _active != null:
		_active.cancel()
	_active = _ability
	
	var result := _active.start()
	if result == MageAbilityPhased.StartResult.BufferAbility:
		_buffer_active_ability()

func tick(delta: float):
	if _active != null:
		_active.update(delta)
	
	if _buffered != null:
		_buffered.tick_cast(delta)

func is_input_handled(event: InputEvent) -> bool:
	if _active == null:
		return false
	
	var result := _active.handle_input(event)
	
	match result:
		CharacterPhasedAbility.HandleInputResult.Trigger:
			_buffer_active_ability()
		CharacterPhasedAbility.HandleInputResult.Cancel:
			_cancel_active_ability()
	
	return result != CharacterPhasedAbility.HandleInputResult.Unhandled

func setup(ability: CharacterAbility) -> CharacterAbilityHandler:
	_ability = ability as CharacterPhasedAbility
	return self

func _buffer_active_ability() -> void:
	if _active != null:
		_buffer_ability(_active)
		_active = null

func _buffer_ability(ability: CharacterPhasedAbility) -> void:
	if _buffered != null:
		_buffered.cancel()
	_buffered = ability

func _cancel_active_ability() -> void:
	if _active != null:
		_active.cancel()
	_active = null
