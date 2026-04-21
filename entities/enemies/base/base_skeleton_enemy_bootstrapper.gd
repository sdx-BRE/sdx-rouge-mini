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
	_boot_ability_system()
	_boot_processor()
	_wire_signals()

func _boot_stats() -> void:
	var stats := EntityStats.from_enemy_data(_entity.data)
	var debuffs := EntityDebuffs.new()
	_entity._status_manager = EntityStatusManager.new(stats, debuffs, _entity.target_point)

func _boot_anim() -> void:
	_entity._anim = EnemyAnimation.from_tree(_entity.anim_tree, _entity.anim_params)

func _boot_target_handler() -> void:
	_entity._target_handler = AiTargetHandler.from_enemy_data(_entity, _entity.data)

func _boot_ability_system() -> void:
	var cooldown_manager := CooldownManager.new()
	var registry := AbilityRegistry.new()
	for ability_data in _entity.abilities:
		registry.register(ability_data, _entity._status_manager.get_stats(), cooldown_manager)

	var target_ctx := AbilityAimingContext.new(EnemyAimingStrategy.new(_entity._target_handler))
	var setup_ctx := AbilitySetupContext.new(EnemySetupStrategy.new(_entity.anim_tree))
	var execute_ctx := AbilityExecuteContext.new(_create_execute_strategy())
	var recover_ctx := AbilityRecoverContext.new(EnemyRecoverStrategy.new(_entity.anim_tree))

	var factory := AbilityExecutionFactory.new(target_ctx, setup_ctx, execute_ctx, recover_ctx)
	var blackboard := AbilityExecutionBlackboard.new()
	var manager := AbilityManager.new(AbilityExecuter.new(blackboard, factory))

	_entity._ability_system = AbilitySystem.new(registry, manager, cooldown_manager)

func _create_execute_strategy() -> AbilityExecuteStrategy:
	return AbilityExecuteStrategy.new()

func _boot_processor() -> void:
	var config := EnemyMovementConfig.from_enemy_data(_entity.data)

	var motion := EnemyMovementMotion.create()
	var context := EnemyMovementContext.new(_entity, _entity.agent, config, motion)
	var kinematics := EnemyKinematics.new(context)
	var state_machine := create_state_machine(context)

	_entity._processor = EntityProcessor.new(_entity.get_viewport())

	_entity._processor.add_process_handler(EnemyStateMachineHandler.new(state_machine))
	_entity._processor.add_process_handler(EntityStatusProcessHandler.new(_entity._status_manager))
	_entity._processor.add_process_handler(EnemyAbilitySystemHandler.new(_entity._ability_system))
	_boot_processor_process_handler()

	_entity._processor.add_physics_handler(EnemyVelocityHandler.new(kinematics))
	_entity._processor.add_physics_handler(EnemyLocomotionHandler.new(kinematics, _entity._anim, config))
	_entity._processor.add_physics_handler(EnemyCollisionsHandler.new(kinematics))

func _boot_processor_process_handler() -> void: pass

func _wire_signals() -> void:
	if _entity.ui is EnemyUI:
		_entity._status_manager.health_changed.connect(_entity.ui.update_health)
	_entity._status_manager.health_reached_zero.connect(_entity.on_die)

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
		_entity._status_manager.get_stats(),
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
