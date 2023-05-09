extends CharacterBody2D


var SPEED = 100
@onready var FactorySc = load("res://evil_factory.tscn")
var under_cursor = false
@onready var ui = get_tree().get_first_node_in_group("UI")


func _ready() -> void:
	set_endpoint()


func set_endpoint():
	$Navigator.target_position = get_tree().get_first_node_in_group("test_target").position


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
