class_name EnemyMovementContext extends RefCounted

var host: CharacterBody3D
var agent: NavigationAgent3D
var config: EnemyMovementConfig
var motion: EnemyMovementMotion

func _init(
	p_host: CharacterBody3D,
	p_agent: NavigationAgent3D,
	p_config: EnemyMovementConfig,
	p_motion: EnemyMovementMotion,
) -> void:
	host = p_host
	agent = p_agent
	config = p_config
	motion = p_motion
