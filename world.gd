extends TileMap
class_name World


signal pollution_changed(new_val: int)


var pollution: int = 0:
	set = set_pollution
	

@export var pollution_tick := 1.0


func set_pollution(val):
		pollution_changed.emit(val)
		pollution = clamp(val, 0, 9223372036854775807)


func change_pollution(val):
		pollution += val
		pollution_changed.emit(pollution)


func emit_pollution() -> void:
	var total_change = get_tree().get_nodes_in_group("pollution_changer")\
		.map(func(it): return it.pollution_change)\
		.reduce(func(accum, number): return accum + number, 0)

	change_pollution(total_change)


func _ready() -> void:
	emit_pollution()
