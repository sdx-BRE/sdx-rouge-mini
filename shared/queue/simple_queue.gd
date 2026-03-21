class_name SimpleQueue extends RefCounted

var _tasks: Array[int] = []

func queue(task: int) -> void:
	if not _tasks.has(task):
		_tasks.append(task)

func consume(task: int) -> bool:
	if _tasks.has(task):
		_tasks.erase(task)
		return true
	return false

func dequeue(task: int) -> void:
	_tasks.erase(task)
