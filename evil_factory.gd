extends PollutionEmitter


var GoblicSc = preload("res://goblin.tscn")

var build_step := 0.1
var under_cursor = false
@onready var ui = get_tree().get_first_node_in_group("UI")


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


func _on_mouse_entered() -> void:
	under_cursor = true


func _on_mouse_exited() -> void:
	under_cursor = false
	
	
func _input(event: InputEvent) -> void:
	if under_cursor and event is InputEventMouseButton and ui.is_destroyer:
		ui.set_cooldown(20)
		ui.is_destroyer = false
		queue_free()
