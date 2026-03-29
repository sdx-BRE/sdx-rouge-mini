class_name MageProcessorAssembler

static func assemble(
	kinematics: MageKinematics,
	motor: MageMotor,
	sensors: MageSensors,
	anim: MageAnimator,
	abilities: MageAbilityHandler,
	resource_generator: MageResourceGenerator,
	airboune_observer: ObserverAirbourne,
	viewport: Viewport,
) -> EntityProcessor:
	var input_handler := MageInputHandler.new(abilities, kinematics)
	var process_handler := MageProcessHandler.new(anim, abilities)
	var velocity_handler := MageVelocityHandler.new(kinematics, motor)
	var blend_handler := MageBlendHandler.new(kinematics, anim)
	var collision_handler := MageCollisionsHandler.new(kinematics)
	
	return MageProcessorAssembler.assemble_parts(
		input_handler,
		resource_generator,
		process_handler,
		airboune_observer,
		sensors,
		velocity_handler,
		blend_handler,
		collision_handler,
		viewport,
	)

static func assemble_parts(
	input_handler: MageInputHandler,
	resource_generator: MageResourceGenerator,
	process_handler: MageProcessHandler,
	airboune_observer: ObserverAirbourne,
	sensors: MageSensors,
	velocity_handler: MageVelocityHandler,
	blend_handler: MageBlendHandler,
	collision_handler: MageCollisionsHandler,
	viewport: Viewport,
) -> EntityProcessor:
	var processor := EntityProcessor.new(viewport)
	
	processor.add_input_handler(input_handler)
	
	processor.add_process_handler(resource_generator)
	processor.add_process_handler(process_handler)
	processor.add_process_handler(airboune_observer)
	
	processor.add_physics_handler(sensors)
	processor.add_physics_handler(velocity_handler)
	processor.add_physics_handler(blend_handler)
	processor.add_physics_handler(collision_handler)
	
	return processor
