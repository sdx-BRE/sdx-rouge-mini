class_name EnemyStateMachineHandler extends PhysicsProcessHandler

var _machine: EnemyStateMachine

func _init(machine: EnemyStateMachine) -> void:
	_machine = machine

func physics_process(delta: float) -> void:
	_machine.process(delta)
