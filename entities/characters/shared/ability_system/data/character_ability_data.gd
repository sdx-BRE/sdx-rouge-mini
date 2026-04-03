class_name CharacterAbilityData extends Resource

@export var cost: AbilityCost
@export var damage: float = 1.0
@export_enum("attack", "dash", "jump", "skill_1", "skill_2", "skill_3") var input: String
