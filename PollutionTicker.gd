extends Timer

signal timeout_set(val: int)


func _ready() -> void:
	wait_time = get_tree().get_first_node_in_group("world").pollution_tick
