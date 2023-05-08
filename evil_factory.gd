extends PollutionEmitter


var GoblicSc = preload("res://goblin.tscn")

func _ready() -> void:
	super._ready()
	var goblin = GoblicSc.instantiate()
	goblin.global_position = global_position
	GeneralLogic.get_world().add_child.call_deferred(goblin)
	
