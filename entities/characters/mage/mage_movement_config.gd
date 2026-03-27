class_name MageMovementConfig extends RefCounted

var camera_node: ThirdPersonCam
var movement_speed: float
var dash_decay: float
var look_at_weight: float

func _init(
	p_camera_node: ThirdPersonCam,
	p_movement_speed: float,
	p_dash_decay: float,
	p_look_at_weight: float,
) -> void:
	camera_node = p_camera_node
	movement_speed = p_movement_speed
	dash_decay = p_dash_decay
	look_at_weight = p_look_at_weight
