class_name ObserverAirbourne extends ProcessHandler

var _host: CharacterBody3D
var _was_on_floor: bool

var _on_ground_subscriber: Array[SubscriberAirbourne]
var _on_air_subscriber: Array[SubscriberAirbourne]

func _init(host: CharacterBody3D) -> void:
	_host = host
	_was_on_floor = _host.is_on_floor()

func process(_delta: float) -> void:
	var is_on_floor := _host.is_on_floor()
	
	if is_on_floor != _was_on_floor:
		if is_on_floor: _notify_on_ground()
		else: 			_notify_on_air()
		
		_was_on_floor = is_on_floor

func subscribe_ground(subscriber: SubscriberAirbourne) -> void:
	_on_ground_subscriber.append(subscriber)

func subscribe_air(subscriber: SubscriberAirbourne) -> void:
	_on_air_subscriber.append(subscriber)

func _notify_on_ground() -> void:
	for subscriber in _on_ground_subscriber:
		subscriber.handle()

func _notify_on_air() -> void:
	for subscriber in _on_air_subscriber:
		subscriber.handle()
