class_name McharacterAbilityAimingResultLocation extends McharacterAbilityAimingResult

var position: Vector3

func _init(pos: Vector3) -> void:
	position = pos

func set_aoe_position(aoe: BaseAoe) -> void:
	aoe.global_position = position
