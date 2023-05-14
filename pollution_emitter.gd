extends Node2D
class_name PollutionEmitter


@export var pollution_change := 10
@export var place_cooldown := 5
@onready var space_state = get_world_2d().direct_space_state
@onready var world = GeneralLogic.get_world()
var created_in_runtime = false
@export var build_progress : float:
	set(val):
		modulate.a = val
		build_progress = val


func _ready() -> void:
	if !created_in_runtime:
		position = world.map_to_local(world.local_to_map(position)) + Vector2(world.tile_set.tile_size / 2)
	
	get_tree().create_timer(0.1).timeout.connect(remove_nav)

	
func remove_nav():
	var phys_params = PhysicsShapeQueryParameters2D.new()
	phys_params.shape = $HitBox.shape
	phys_params.transform = $HitBox.global_transform
	phys_params.collision_mask = 4

	var collide_points = space_state.collide_shape(phys_params, 128)

	var used_cells = {}
	for it in collide_points:
		var cell_coords = world.local_to_map(it)
		if cell_coords not in used_cells:
			used_cells[cell_coords] = null
			var atlas_coords := world.get_cell_atlas_coords(0, cell_coords)
			world.set_cell(0, cell_coords, 0, atlas_coords, 1)
			pass
