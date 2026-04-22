class_name AbilityWindupMelee extends AbilityWindup

@export var anim_trigger: StringName = &""
@export var anim_name: StringName = &""

func create_setup_handler(context: AbilitySetupContext, blackboard: AbilityExecutionBlackboard) -> AbilitySetupWindupHandler:
	return AbilitySetupMeleeHandler.new(context, blackboard)
