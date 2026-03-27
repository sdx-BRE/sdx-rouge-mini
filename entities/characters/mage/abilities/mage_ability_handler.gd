class_name MageAbilityHandler extends RefCounted

var _registry: MageAbilityRegistry

var _active: MageAbilityPhased
var _buffered: MageAbilityPhased

func _init(registry: MageAbilityRegistry) -> void:
	_registry = registry

func try_activate_ability(id: MageAbilityId.Id) -> void:
	var ability: MageAbilityBase = _registry.get_ability(id)
	
	if ability == null:
		return
	
	if not ability.has_resources():
		return
	
	if ability is MageAbilityInstant:
		if ability.trigger() == MageAbilityInstant.Result.Trigger:
			ability.use_resources()
		return
	
	if _active != null:
		_active.cancel()
	_active = ability
	
	var result := _active.start()
	if result == MageAbilityPhased.StartResult.Cast:
		_buffer_active_ability()

func process_abilities(delta: float) -> void:
	if _active != null:
		_active.update(delta)
	
	if _buffered != null:
		_buffered.tick_cast(delta)

func handle_input(event: InputEvent) -> bool:
	if _active != null:
		var handle_result := _active.handle_input(event)
		if _is_input_handled(handle_result):
			match handle_result:
				MageAbilityPhased.HandleInputResult.Trigger: _buffer_active_ability()
				MageAbilityPhased.HandleInputResult.Cancel: _cancel_active_ability()
			
			return true
	
	var actions := _registry.get_actions()
	for action in actions:
		if event.is_action_pressed(action):
			try_activate_ability(actions[action])
			return true
	
	return false

func execute_buffered_ability() -> void:
	if _buffered != null:
		_buffered.execute()
		_buffered.use_resources()
		_buffered = null

func _buffer_active_ability() -> void:
	if _active != null:
		_buffer_ability(_active)
		_active = null

func _buffer_ability(ability: MageAbilityBase) -> void:
	if _buffered != null:
		_buffered.cancel()
	_buffered = ability

func _cancel_active_ability() -> void:
	if _active != null:
		_active.cancel()
	_active = null

func _is_input_handled(result: MageAbilityPhased.HandleInputResult) -> bool:
	return result == MageAbilityPhased.HandleInputResult.Trigger or result == MageAbilityPhased.HandleInputResult.Cancel
