class_name EnemyStateMachineHandler extends ProcessHandler

var _machine: EnemyStateMachine

func _init(machine: EnemyStateMachine) -> void:
	_machine = machine

func process(delta: float) -> void:
	_machine.process(delta)
