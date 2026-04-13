class_name AbilityCost extends Resource

enum Type {
	Instant,
	Tick,
	External,
}

@export var type: Type = Type.External
@export var mana: float = 0.0
@export var stamina: float = 0.0
