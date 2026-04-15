class_name CharacterAbilityExecuteDeliveryContinuousHandler extends CharacterAbilityExecuteDeliveryHandler

var _data: CharacterAbilityDeliveryContinuous
var _node: Node

func setup(data: CharacterAbilityDelivery) -> void:
	_data = data
	
	_node = _data.scene.instantiate()
	_emit_cost_required()
	_context.spawn_node(_node)

func tick(delta: float) -> void:
	_emit_continuous_cost_required(delta)

func release() -> void:
	_node.queue_free()
