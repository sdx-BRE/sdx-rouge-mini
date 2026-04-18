class_name EnemyAbilitySystemHandler extends ProcessHandler

var _ability_system: CharacterAbilitySystem

func _init(ability_system: CharacterAbilitySystem) -> void:
	_ability_system = ability_system

func process(delta: float) -> void:
	_ability_system.tick(delta)
