extends Node2D


@export var pollution_change = 10


var pollution: int = 0:
	set(value):
		pollution_changed.emit(value)
		pollution = value


signal pollution_changed(new_val: int)


func _on_timer_timeout() -> void:
	pollution += pollution_change
