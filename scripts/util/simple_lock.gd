class_name SimpleLock extends RefCounted

var _locks: Array[int] = []
	
func lock(key: int) -> void:
	if not _locks.has(key):
		_locks.append(key)
	
func unlock(key: int) -> void:
	if _locks.has(key):
		_locks.erase(key)
	
func is_locked(key: int) -> bool:
	return _locks.has(key)
