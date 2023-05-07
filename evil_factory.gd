extends Node2D


@export var pollution_change = 10

signal pollution_changed(new_val: int)


func _on_timer_timeout() -> void:
	pollution_changed.emit(pollution_change)
