extends PollutionEmitter


var GoblicSc = preload("res://goblin.tscn")

var build_step := 0.1
@export var build_progress : float = 0:
	set(val):
		modulate.a = val
		build_progress = val


func _on_spawn_timer_timeout() -> void:
	if build_progress >= 1:
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


func build_inc():
	build_progress += build_step
