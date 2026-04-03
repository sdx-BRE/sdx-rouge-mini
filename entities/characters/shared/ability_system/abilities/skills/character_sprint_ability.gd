class_name CharacterSprintAbility extends CharacterChanneledAbility

var _sprint_data: CharacterAbilitySprint

func _init(data: CharacterAbilitySprint, stats: EntityStats, context: ChanneledContext) -> void:
	super(data, stats, context)
	_sprint_data = data

func tick(_delta: float) -> TickResult:
	_context.use_sprinting_speed()
	
	return TickResult.Consume

func end() -> void:
	_context.use_normal_speed()
