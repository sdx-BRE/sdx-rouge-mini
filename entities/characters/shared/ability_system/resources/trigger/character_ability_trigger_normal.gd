class_name CharacterAbilityTriggerNormal extends CharacterAbilityTrigger

func create_handler(
	blackboard: CharacterAbilityExecutionBlackboard,
) -> CharacterAbilityExecuteTriggerHandler:
	return CharacterAbilityExecuteTriggerNormalHandler.new(blackboard)
