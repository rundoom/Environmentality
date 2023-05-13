extends PollutionEmitter


var GoblicSc = preload("res://goblin.tscn")


func _on_spawn_timer_timeout() -> void:
	var point = PhysicsPointQueryParameters2D.new()
	point.collision_mask = 1

	for i in range(0, 1000, 125):
		$Path2D/PathFollow2D.progress_ratio = float(i)/1000
		point.position = $Path2D/PathFollow2D.global_position
		
		if space_state.intersect_point(point).is_empty():
			var goblin = GoblicSc.instantiate()
			goblin.global_position = point.position
			GeneralLogic.get_world().add_child.call_deferred(goblin)
			break


func _ready() -> void:
	super._ready()
	if OS.is_debug_build():
		_on_spawn_timer_timeout()
