class_name CharacterAbilityWindup extends Resource

func create_setup_handler(context: CharacterAbilitySetupContext) -> CharacterAbilitySetupWindupHandler:
	return CharacterAbilitySetupWindupHandler.new(context)

func create_recover_handler(context: CharacterAbilityRecoverContext) -> CharacterAbilityRecoverWindupHandler:
	return CharacterAbilityRecoverWindupHandler.new(context)
