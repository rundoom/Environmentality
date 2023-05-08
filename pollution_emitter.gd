extends Node2D
class_name PollutionEmitter


@export var pollution_change := 10
@export var place_cooldown := 5.0


func _ready() -> void:
	get_tree().get_first_node_in_group("navigator").cut_polygon(self)
