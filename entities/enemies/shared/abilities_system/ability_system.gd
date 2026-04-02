class_name AbilitySystem extends RefCounted

var _registry: AbilityRegistry
var _resolver: AbilityResolver
var _cooldown_manager: CooldownManager

func _init(
	registry: AbilityRegistry,
	resolver: AbilityResolver,
	cooldown_manager: CooldownManager,
) -> void:
	_registry = registry
	_resolver = resolver
	_cooldown_manager = cooldown_manager

func try_activate_ability(ability_id: int) -> void:
	var ability := _registry.get_ability(ability_id)
	if ability == null:
		push_warning("[WARN][AbilitySystem.try_activate_ability(%d)]: Ability not found!" % ability_id)
		return
	
	var handler := _resolver.resolve(ability)
	if handler != null and not _cooldown_manager.has_ability_cooldown(ability):
		handler.try_activate()

func execute_cast() -> void:
	_resolver.execute_cast()

func tick(delta: float) -> void:
	_cooldown_manager.tick(delta)

func has_cooldown(ability_id: int) -> bool:
	return _cooldown_manager.has_cooldown(ability_id)
