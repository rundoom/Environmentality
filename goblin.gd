extends CharacterBody2D


@export var SPEED = 200
@onready var FactorySc := load("res://evil_factory.tscn") as PackedScene
var under_cursor = false
@onready var ui = get_tree().get_first_node_in_group("UI")
@onready var space_state = get_world_2d().direct_space_state
@onready var world = GeneralLogic.get_world()
@onready var factory: PollutionEmitter
signal exploded

func _ready() -> void:
	set_endpoint()
	exploded.connect(ui. reduce_cooldown)


func set_endpoint():
	var unbuilded := get_tree().get_nodes_in_group("evil_factory").filter(func(it): return it.build_progress < 1)
	if !unbuilded.is_empty():
		$Navigator.target_position = unbuilded[0].position
	else:
		if factory == null :factory = FactorySc.instantiate()
		factory.build_inc()
		var hitbox = factory.find_child("HitBox")
		var phys_params = PhysicsShapeQueryParameters2D.new()
		phys_params.shape = hitbox.shape
		phys_params.collision_mask = 2

		for cell in GeneralLogic.get_world().get_used_cells(0):
			phys_params.transform = Transform2D(0, world.map_to_local(cell))
			if space_state.intersect_shape(phys_params).is_empty():
				$Navigator.target_position = world.map_to_local(cell)
				break


func _physics_process(delta: float) -> void:
	if OS.is_debug_build(): $Line2D.points = Array($Navigator.get_current_navigation_path()).map(func(it): return it - position)
	velocity = global_position.direction_to($Navigator.get_next_path_position()) * SPEED
	move_and_slide()


func _on_mouse_entered() -> void:
	under_cursor = true


func _on_mouse_exited() -> void:
	under_cursor = false


func _input(event: InputEvent) -> void:
	if under_cursor and event is InputEventMouseButton and ui.building_shadow == null:
		exploded.emit()
		$DeathParticles.explode()
		queue_free()


func _on_navigator_target_reached() -> void:
	queue_free()
	factory.global_position = global_position
	world.add_child(factory)


func _on_navigator_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_collision_checker_body_entered(body: Node2D) -> void:
	if body.is_in_group("evil_factory") and body.build_progress < 1:
		queue_free()
		body.build_inc()
	else:
		set_endpoint()


func _on_tree_exiting() -> void:
	if factory != null and factory.get_parent() == get_tree():
		factory.queue_free()
