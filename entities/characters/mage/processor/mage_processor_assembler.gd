class_name MageProcessorAssembler

static func assemble(
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
