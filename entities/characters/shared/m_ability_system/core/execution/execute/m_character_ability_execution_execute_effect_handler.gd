class_name MCharacterAbilityExecutionExecuteEffectHandler extends RefCounted

signal finished()
signal canceled()

var _ability: MCharacterAbility
var _context: MCharacterAbilityExecutionExecuteContext

func _init(ability: MCharacterAbility, context: MCharacterAbilityExecutionExecuteContext) -> void:
	_ability = ability
	_context = context

func setup(_data: MCharacterAbilityEffect) -> void:
	pass

func execute(_aiming_result: McharacterAbilityAimingResult) -> void:
	pass

func tick(_delta: float) -> void:
	pass

func release() -> void:
	pass

func _emit_finished() -> void:
	finished.emit()

func _emit_canceled() -> void:
	canceled.emit()

func _setup_when_ability(node: Node, data: MCharacterAbilityEffect) -> void:
	_when_ability(node, data, _setup_ability)

func _launch_when_ability(node: Node, data: MCharacterAbilityEffect) -> void:
	_when_ability(node, data, _launch_ability)

func _setup_ability(ability: AbilityEntity, data: MCharacterAbilityEffect) -> void:
	ability.setup_mcharacter_ability(data, _context)

func _launch_ability(ability: AbilityEntity, data: MCharacterAbilityEffect) -> void:
	ability.launch_mcharacter_ability(data, _context)

func _when_ability(node: Node, data: MCharacterAbilityEffect, then: Callable) -> void:
	if node is AbilityEntity:
		then.call(node, data)

func _use_resources() -> void:
	if _ability._data.cost.type == AbilityCost.Type.Instant:
		_ability.use_resources()
