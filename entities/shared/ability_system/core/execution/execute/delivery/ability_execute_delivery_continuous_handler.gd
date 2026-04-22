class_name AbilityExecuteDeliveryContinuousHandler extends AbilityExecuteDeliveryHandler

var _data: AbilityDeliveryContinuous
var _node: Node

func setup(data: AbilityDelivery) -> void:
	_data = data
	
	_setup_scene()

func execute_tick(timespan: float, _aiming_result: AbilityAimingResult) -> void:
	_when_continuous_abiltiy(_node, _tick_damage)
	_emit_continuous_cost_required(timespan)

func release() -> void:
	_node.queue_free()

func cancel() -> void:
	print("cancel")
	_node.queue_free()

func _setup_scene() -> void:
	_node = _data.scene.instantiate()
	_setup_when_ability(_node, _data)
	
	_context.spawn_weapon_child(_node)
	_launch_when_ability(_node, _data)

func _when_continuous_abiltiy(node: Node, then: Callable) -> void:
	if node is ContinuousAbility:
		then.call(node)

func _tick_damage(ability: ContinuousAbility) -> void:
	ability.tick_damage()
