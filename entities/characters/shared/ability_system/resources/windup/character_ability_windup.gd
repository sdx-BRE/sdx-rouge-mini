class_name CharacterAbilityWindup extends Resource

func create_handler(context: CharacterAbilitySetupContext) -> CharacterAbilitySetupWindupHandler:
	return CharacterAbilitySetupWindupHandler.new(context)
