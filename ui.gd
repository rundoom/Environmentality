extends CanvasLayer


@onready var world = get_tree().get_first_node_in_group("world")


var abbreviation = {
	1000_000_000: "B",
	1000_000: "M",
	1000: "K",
}

var global_cooldown := 0

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
		building_shadow.position = event.position
	if building_shadow != null and event is InputEventMouseButton:
		building_shadow.queue_free()
		var real_tree = TreeSc.instantiate()
		world.add_child(real_tree)
		real_tree.position = event.position
		
		var cooldown_tween = get_tree().create_tween()
		
		for it in get_tree().get_nodes_in_group("cooldown_holder"):
			it.value = it.max_value
			toogle_cooldown_lockable(true)
			cooldown_tween.tween_property(it, "value", 0, real_tree.place_cooldown)
			cooldown_tween.finished.connect(toogle_cooldown_lockable.bind(false))


func _on_create_tree_pressed() -> void:
	building_shadow = GeneralLogic.shadow_building(TreeSc)
	world.add_child(building_shadow)


func toogle_cooldown_lockable(disable: bool):
	for button in get_tree().get_nodes_in_group("cooldown_lockable"):
		button.disabled = disable
