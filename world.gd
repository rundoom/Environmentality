extends TileMap


signal pollution_changed(new_val: int)


var pollution: int = 0:
	set = set_pollution
	

@export var pollution_tick := 1.0


func set_pollution(val):
		pollution_changed.emit(val)
		pollution = val
		

func chnage_pollution(val):
		pollution += val
		pollution_changed.emit(pollution)


func _on_pollution_timer_timeout() -> void:
	var changes_arr = get_tree().get_nodes_in_group("pollution_changer").map(func(it): return it.pollution_change)
	var total_change = changes_arr.reduce(func(accum, number): return accum + number, 0)
	chnage_pollution(total_change)


func _ready() -> void:
	_on_pollution_timer_timeout()
