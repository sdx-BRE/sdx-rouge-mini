class_name AbilitySystem extends RefCounted

var _registry: AbilityRegistry
var _resolver: AbilityResolver

func _init(
	registry: AbilityRegistry,
	resolver: AbilityResolver,
) -> void:
	_registry = registry
	_resolver = resolver

func try_activate_ability(ability_id: int) -> void:
	var ability := _registry.get_ability(ability_id)
	if ability == null:
		push_warning("[WARN][AbilitySystem.try_activate_ability(%d)]: Ability not found!" % ability_id)
		return
	
	var handler := _resolver.resolve(ability)
	if handler != null:
		handler.try_activate()

func execute_cast() -> void:
	_resolver.execute_cast()
