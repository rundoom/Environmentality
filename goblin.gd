extends CharacterBody2D


var SPEED = 100
@onready var FactorySc := load("res://evil_factory.tscn") as PackedScene
var under_cursor = false
@onready var ui = get_tree().get_first_node_in_group("UI")
@onready var space_state = get_world_2d().direct_space_state
@onready var world = GeneralLogic.get_world()
@onready var factory: PollutionEmitter


func _ready() -> void:
	set_endpoint()


func set_endpoint():
	factory = FactorySc.instantiate()
	var hitbox = factory.find_child("HitBox")
	var phys_params = PhysicsShapeQueryParameters2D.new()
	phys_params.shape = hitbox.shape
	phys_params.collision_mask = 1
	
	for cell in GeneralLogic.get_world().get_used_cells(0):
		phys_params.transform = Transform2D(0, world.map_to_local(cell))
		if space_state.intersect_shape(phys_params).is_empty():
			$Navigator.target_position = world.map_to_local(cell)
			break
	
	
func _physics_process(delta: float) -> void:
	velocity = global_position.direction_to($Navigator.get_next_path_position()) * SPEED
	move_and_slide()


func _on_mouse_entered() -> void:
	under_cursor = true


func _on_mouse_exited() -> void:
	under_cursor = false


func _input(event: InputEvent) -> void:
	if under_cursor and event is InputEventMouseButton and ui.building_shadow == null:
		queue_free()


func _on_navigator_target_reached() -> void:
	queue_free()
	factory.global_position = global_position
	world.add_child(factory)
