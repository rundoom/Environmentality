extends Node
class_name GeneralLogicCl


func get_world():
	return get_tree().get_first_node_in_group("world")
