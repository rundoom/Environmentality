extends CanvasLayer


@onready var world = get_tree().get_first_node_in_group("world") as World


var abbreviation = {
	1000_000_000: "B",
	1000_000: "M",
	1000: "K",
}

var text_template = "{0}{1}"
var old_pollution := 0:
	set(value):
		var out_text: String = ""
		for it in abbreviation.keys():
			if old_pollution >= it:
				out_text = text_template.format([str(float(old_pollution)/it).pad_decimals(3).left(5), abbreviation[it]])
				break
		if out_text.is_empty():
			out_text = (str(old_pollution)).pad_decimals(3).left(5)
			
		$PollutionMeter.text = str(out_text)
		old_pollution = value
		
		
var polution_tween: Tween
var tweening_interval: float

var TreeSc = preload("res://tree.tscn")
var ShadowSc = preload("res://shadow_building.tscn")

var building_shadow: Node2D
		
		
func _ready() -> void:
	tweening_interval = world.pollution_tick

		
func set_tweening_interval(val: float):
	tweening_interval = val


func set_pollution(new_val: int):
	if polution_tween != null: polution_tween.stop()
		
	polution_tween = create_tween()
	polution_tween.tween_property(self, "old_pollution", new_val, tweening_interval)


func _input(event):
	if building_shadow != null and event is InputEventMouseMotion:
		var snapped_pos = world.map_to_local(world.local_to_map(event.position)) + Vector2(world.tile_set.tile_size / 2)
		building_shadow.position = snapped_pos
		
	if building_shadow != null and event is InputEventMouseButton and event.get_button_index() == MOUSE_BUTTON_LEFT and !building_shadow.is_overlapping:
		building_shadow.queue_free()
		var real_tree = TreeSc.instantiate()
		real_tree.created_in_runtime = true
		real_tree.position = building_shadow.position
		world.add_child(real_tree)
		
		toogle_cooldown_lockable(true)
		
		for it in get_tree().get_nodes_in_group("cooldown_holder"):
			it.max_value = real_tree.place_cooldown
			it.value = it.max_value
	if building_shadow != null and event is InputEventMouseButton and event.get_button_index() == MOUSE_BUTTON_RIGHT:
		building_shadow.queue_free()


func _on_create_tree_pressed() -> void:
	building_shadow = ShadowSc.instantiate()
	building_shadow.ShadowedSc = TreeSc
	world.add_child(building_shadow)


func toogle_cooldown_lockable(disable: bool):
	for button in get_tree().get_nodes_in_group("cooldown_lockable"):
		button.disabled = disable


func reduce_cooldown():
	for it in get_tree().get_nodes_in_group("cooldown_holder"):
		it.value = clamp(it.value - 1, 0, 2048)
		if it.value == 0: toogle_cooldown_lockable(false)
			
