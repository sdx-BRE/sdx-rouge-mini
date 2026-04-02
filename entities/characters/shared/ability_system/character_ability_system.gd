class_name CharacterAbilitySystem extends RefCounted

var _registry: CharacterAbilityRegistry
var _manager: CharacterAbilityManager

func _init(
	registry: CharacterAbilityRegistry,
	manager: CharacterAbilityManager,
) -> void:
	_registry = registry
	_manager = manager

func handle_input(event: InputEvent) -> bool:
	if event.is_echo():
		return false
	
	if _manager.is_handling_active_ability(event):
		return true
	
	var actions := _registry.get_actions()
	for action in actions:
		if event.is_action(action):
			var state := CharacterAbilitySystem.TriggerState.Press if event.is_pressed() else CharacterAbilitySystem.TriggerState.Release
			
			_try_activate_ability(actions[action], state)
			return true
	
	return false

func tick(delta: float) -> void:
	_manager.tick(delta)

func _try_activate_ability(
	id: CharacterAbilityRegistry.Id,
	state: TriggerState,
) -> void:
	var ability: CharacterAbility = _registry.get_ability(id)
	
	if ability == null:
		return
	
	if not ability.has_resources():
		return
	
	_manager.try_activate(ability, state)

enum TriggerState {
	Press,
	Release,
}
