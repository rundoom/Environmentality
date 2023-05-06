extends Timer

signal timeout_set(val: int)


func _ready() -> void:
	print(wait_time)
	timeout_set.emit(wait_time)
