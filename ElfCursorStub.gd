extends Sprite2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		position = event.position
