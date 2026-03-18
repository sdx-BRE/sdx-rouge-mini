class_name DbgHelper
extends RefCounted

var _do_after_counter = 0
func do_after(cb: Callable, count: int) -> void:
	if _do_after_counter >= count:
		cb.call()
		_do_after_counter = 0
	else:
		_do_after_counter += 1

var _once_called = false
func only_once(cb: Callable):
	if not _once_called:
		cb.call()
		_once_called = true

var _call_every_count = 0
func call_every(cb: Callable, count: int, force: bool = false):
	if force:
		cb.call()
	
	if _call_every_count == 0:
		cb.call()
	_call_every_count += 1
	
	if _call_every_count == count:
		_call_every_count = 0

static func tprint(...args: Array) -> void:
	var msg = " | ".join(args)
	
	var t = Time.get_time_dict_from_system()
	var ms = Time.get_ticks_msec() % 1000
	var ts = "[%02d:%02d:%02d:%03d]" % [t.hour, t.minute, t.second, ms]
	print(ts, " ", str(msg))
