extends Node
class_name GeneralLogicCl


func shadow_building(build: PackedScene) -> Node2D:
	var shadow = build.instantiate() as Node2D
	shadow.script = null
	shadow.remove_from_group("pollution_changer")
	for it in shadow.find_children("*"):
		it.script = null
	shadow.modulate = Color(1, 1, 1, 0.5)
	return shadow


func get_world():
	return get_tree().get_first_node_in_group("world")
