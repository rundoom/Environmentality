extends TileMap


signal pollution_changed(new_val: int)


var pollution: int = 0:
	set = set_pollution
	

var pollution_tick := 1.0


func set_pollution(val):
		pollution_changed.emit(val)
		pollution = val
		

func chnage_pollution(val):
		pollution += val
		pollution_changed.emit(pollution)
