## 	Idea:
## 
##	Four steps:
##		1. Targeting (None, Mouse Target, Location, Direction)
##		2. Trigger (Normal, Channeled, Charged)
##		3. Windup (Animated, Instant)
##		4. Execution/delivery (Projectile, AoE, Buff)
## 
class_name AbilitySystem extends RefCounted

var _registry: AbilityRegistry
var _manager: AbilityManager
var _cooldown_manager: CooldownManager

func _init(
	registry: AbilityRegistry,
	manager: AbilityManager,
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
			var state := AbilitySystem.TriggerState.Press if event.is_pressed() else AbilitySystem.TriggerState.Release
			
			handle_ability_action(actions[action], state)
			return true
	
	return false

func try_activate_ability(id: StringName) -> void:
	handle_ability_action(id, TriggerState.Press)

func try_release_ability(id: StringName) -> void:
	handle_ability_action(id, TriggerState.Release)

func notify_animation_event() -> void:
	_manager.handle_animation_event()

func use_ability_resources(id: StringName) -> void:
	var ability := _registry.get_ability(id)
	if ability == null:
		return
	
	ability.use_resources()

func has_ability_resources(id: StringName) -> bool:
	var ability := _registry.get_ability(id)
	if ability == null:
		return false
	
	return ability.has_resources()

func start_ability_cooldown(id: StringName) -> void:
	var ability := _registry.get_ability(id)
	if ability == null:
		return
	ability.start_cooldown_external()

func tick(delta: float) -> void:
	_manager.tick(delta)
	_cooldown_manager.tick(delta)

enum TriggerState {
	Press,
	Release,
}

func handle_ability_action(
	id: StringName,
	state: TriggerState,
) -> void:
	var ability := _registry.get_ability(id)
	
	if ability == null:
		return
	
	if state == TriggerState.Press:
		if not ability.check_resources() \
			or _cooldown_manager.has_cooldown(ability._data.id):
			return
	
	_manager.handle_ability_action(ability, state)
