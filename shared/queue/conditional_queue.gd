class_name ConditionalQueue extends RefCounted

var _tasks: Dictionary[StringName, Dictionary] = {}

func queue(
	category: Dictionary, 
	task: int, 
	condition: Callable, 
	action: Callable, 
	overwrite: bool = true
):
	var cat = str(category)
	
	if not _tasks.has(cat):
		_tasks[cat] = {}
	
	if overwrite or not _tasks[cat].has(task):
		_tasks[cat][task] = Task.new(condition, action)

func process(delta: float) -> void:
	for category in _tasks.keys():
		var category_task = _tasks[category]
		
		for task_id in category_task.keys():
			var task: Task = category_task[task_id]
			
			if task.try_execute(delta):
				_tasks[category].erase(task_id)

class Task extends RefCounted:
	var _condition: Callable
	var _action: Callable
	var data: Dictionary = {}

	func _init(condition: Callable, action: Callable) -> void:
		_condition = condition
		_action = action
	
	func try_execute(delta: float):
		if _condition.call(delta, self):
			_action.call(delta)
			return true
		return false
	
