class_name NCharacterAbilityHandlerPhased extends NCharacterAbilityHandler

var _context: NCharacterAbilityContextPhased
var _ability: NCharacterAbilityPhased

var _active: NCharacterAbilityPhased
var _buffered: NCharacterAbilityPhased

func _init(
	cooldown_manager: CooldownManager,
	context: NCharacterAbilityContextPhased,
) -> void:
	super(cooldown_manager)
	_context = context

func setup(ability: NCharacterAbility) -> void:
	_ability = NCharacterAbilityPhased.new(ability, _context)

func try_activate(state: NCharacterAbilitySystem.TriggerState) -> void:
	if state != NCharacterAbilitySystem.TriggerState.Press \
		or not _ability.has_resources() \
		or _cooldown_manager.has_character_cooldown(_ability._data):
		return
	
	if _active != null:
		_active.cancel()
	_active = _ability
	
	var result := _active.start()
	if result == NCharacterAbilityPhased.StartResult.BufferAbility:
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
		NCharacterAbilityPhased.HandleInputResult.Trigger:
			_buffer_active_ability()
		NCharacterAbilityPhased.HandleInputResult.Cancel:
			_cancel_active_ability()
	
	return result != NCharacterAbilityPhased.HandleInputResult.Unhandled

func execute_buffered_ability() -> void:
	if _buffered != null:
		var result := _buffered.execute()
		if result == NCharacterAbilityPhased.ExecuteResult.Trigger:
			_buffered.use_resources()
			_cooldown_manager.start_character_cooldown(_buffered._data)
		_buffered = null

func _buffer_active_ability() -> void:
	if _active != null:
		_buffer_ability(_active)
		_active = null

func _buffer_ability(ability: NCharacterAbilityPhased) -> void:
	if _buffered != null:
		_buffered.cancel()
	_buffered = ability

func _cancel_active_ability() -> void:
	if _active != null:
		_active.cancel()
	_active = null
