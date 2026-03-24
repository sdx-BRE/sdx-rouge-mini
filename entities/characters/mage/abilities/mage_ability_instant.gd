class_name MageAbilityInstant extends MageAbilityBase

func trigger() -> Result: 
	push_error("[Error][MageAbilityInstant]: trigger() must be overwritten by child implementations")
	return Result.Abort

enum Result {
	Trigger,
	Abort,
}
