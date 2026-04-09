class_name BaseSkeletonEnemyBootstrapper extends RefCounted

var _entity: BaseSkeletonEnemy

func _init(
	entity: BaseSkeletonEnemy
) -> void:
	_entity = entity

func boot() -> void:
	_boot_stats()
	_boot_anim()
	_boot_target_handler()
	_boot_processor()
	_wire_signals()

func _boot_stats() -> void:
	_entity._stats = EntityStats.from_enemy_data(_entity.data)

func _boot_anim() -> void:
	_entity._anim = EnemyAnimation.from_tree(_entity.anim_tree, _entity.anim_params)

func _boot_target_handler() -> void:
	_entity._target_handler = AiTargetHandler.from_enemy_data(_entity, _entity.data)

func _boot_processor() -> void:
	var config := EnemyMovementConfig.from_enemy_data(_entity.data)
	
	var motion := EnemyMovementMotion.create()
	var context := EnemyMovementContext.new(_entity, _entity.agent, config, motion)
	var kinematics := EnemyKinematics.new(context)
	var state_machine := create_state_machine(context)
	
	_entity._processor = EntityProcessor.new(_entity.get_viewport())
	
	_entity._processor.add_process_handler(EnemyStateMachineHandler.new(state_machine))
	_boot_processor_process_handler()
	
	_entity._processor.add_physics_handler(EnemyVelocityHandler.new(kinematics))
	_entity._processor.add_physics_handler(EnemyLocomotionHandler.new(kinematics, _entity._anim, config))
	_entity._processor.add_physics_handler(EnemyCollisionsHandler.new(kinematics))

func _boot_processor_process_handler() -> void: pass

func _wire_signals() -> void:
	if _entity.ui is EnemyUI:
		_entity._stats.health_changed.connect(_entity.ui.update_health)
	_entity._stats.health_reached_zero.connect(_entity.on_die)
	
	_entity.fov.area_entered.connect(_entity._on_fov_entered)
	_entity.fov.area_exited.connect(_entity._on_fov_exited)

func create_state_machine(
	movement_context: EnemyMovementContext,
) -> EnemyStateMachine:
	var aggro_rule := StateTransitionRule.new(
		StateTransition.AGGRO,
		func() -> bool: return _entity._target_handler.update_and_has_target()
	)
	
	var controller := EnemyController.new(movement_context, []) # Todo: Properly implement patrol points
	var blackboard := EnemyBlackboard.from_data(_entity.data)
	
	var attack_context := _create_attack_context()
	var context := StateContext.new(
		_entity._target_handler, 
		controller, 
		blackboard, 
		_entity.data, 
		_entity._stats, 
		attack_context
	)
	
	var waiting_state := WaitingState.new(context)
	var walking_state := WalkingState.new(context)
	var aggro_state := AggroState.new(context)
	
	var states: Dictionary[int, StateBase] = {}
	states.set(StateTransition.AGGRO, aggro_state)
	states.set(StateTransition.WALKING, walking_state)
	states.set(StateTransition.WAITING, waiting_state)
	
	return EnemyStateMachine.new(walking_state, states, context, [aggro_rule])

func _create_attack_context() -> StateContextAttack:
	return StateContextAttack.new()
