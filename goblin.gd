extends CharacterBody2D


var SPEED = 100


func _on_navigator_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity

	move_and_slide()


func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(set_endpoint)


func set_endpoint():
	$Navigator.target_position = get_tree().get_first_node_in_group("test_target").position


func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity = global_position.direction_to($Navigator.get_next_path_position()) * SPEED
