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
	
	if ability is MageAbilityInstant:
		ability.trigger()
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
	if _active != null and _active.handle_input(event):
		_buffer_active_ability()
		return true
	
	var actions := _registry.get_actions()
	for action in actions:
		if event.is_action_pressed(action):
			try_activate_ability(actions[action])
			return true
	
	return false

func execute_buffered_cast() -> void:
	if _buffered != null:
		_buffered.execute()
		_buffered = null

func _buffer_active_ability() -> void:
	if _active != null:
		_buffer_ability(_active)
		_active = null

func _buffer_ability(ability: MageAbilityBase) -> void:
	if _buffered != null:
		_buffered.cancel()
	_buffered = ability
