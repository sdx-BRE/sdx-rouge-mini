class_name NCharacterAbilitySystem extends RefCounted

var _registry: NCharacterAbilityRegistry
var _manager: NCharacterAbilityManager
var _cooldown_manager: CooldownManager

func _init(
	registry: NCharacterAbilityRegistry,
	manager: NCharacterAbilityManager,
	cooldown_manager: CooldownManager,
) -> void:
	_registry = registry
	_manager = manager
	_cooldown_manager = cooldown_manager

func handle_input(event: InputEvent) -> bool:
	if event.is_echo():
		return false
	
	if _manager.is_handling_active_ability(event):
		return true
	
	var actions := _registry.get_actions()
	for action in actions:
		if event.is_action(action):
			var state := NCharacterAbilitySystem.TriggerState.Press if event.is_pressed() else NCharacterAbilitySystem.TriggerState.Release
			
			_try_activate_ability(actions[action], state)
			return true
	
	return false

func execute_buffered_ability() -> void:
	_manager.execute_buffered_ability()

func on_ability_triggered(id: int) -> void:
	var ability := _registry.get_ability(id)
	if ability == null:
		return
	
	ability.use_resources()

func has_resources(id: int) -> bool:
	var ability := _registry.get_ability(id)
	if ability == null:
		return false
	
	return ability.has_resources()

func tick(delta: float) -> void:
	_manager.tick(delta)
	_cooldown_manager.tick(delta)

func _try_activate_ability(
	id: int,
	state: TriggerState,
) -> void:
	var ability := _registry.get_ability(id)
	
	if ability == null:
		return
	
	_manager.try_activate(ability, state)

enum TriggerState {
	Press,
	Release,
}
