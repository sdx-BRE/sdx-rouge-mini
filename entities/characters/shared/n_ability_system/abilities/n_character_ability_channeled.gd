class_name NCharacterAbilityChanneled extends RefCounted

var base: NCharacterAbility

func _init(ability: NCharacterAbility) -> void:
	base = ability

func tick(delta: float) -> TickResult:
	push_error("[Error][CharacterChanneledAbility]: tick() must be overwritten by child implementations, delta: ", delta)
	return TickResult.NoCost

func end() -> void:
	push_error("[Error][CharacterChanneledAbility]: end() must be overwritten by child implementations")

enum TickResult {
	Consume,
	NoCost,
}
