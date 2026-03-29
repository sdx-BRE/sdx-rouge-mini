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
	var processor := EntityProcessor.new(viewport)
	
	processor.add_input_handler(MageInputHandler.new(abilities, kinematics))
	
	processor.add_process_handler(resource_generator)
	processor.add_process_handler(MageProcessHandler.new(anim, abilities))
	processor.add_process_handler(airboune_observer)
	
	processor.add_physics_handler(sensors)
	processor.add_physics_handler(MageVelocityHandler.new(kinematics, motor))
	processor.add_physics_handler(MageBlendHandler.new(kinematics, anim))
	processor.add_physics_handler(MageCollisionsHandler.new(kinematics))
	
	return processor
