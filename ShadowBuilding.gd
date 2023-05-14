extends Area2D


@export var ShadowedSc: PackedScene
var is_overlapping := false

func _ready() -> void:
	var shadowed = ShadowedSc.instantiate()
	var hitbox = shadowed.find_child("HitBox") as CollisionShape2D
	$CollisionShape2D.shape = hitbox.shape
	var sprite = shadowed.find_child("Sprite") as Sprite2D
	$Sprite2D.texture = sprite.texture


func _on_body_entered(body: Node2D) -> void:
	modulate.g = 0
	modulate.b = 0
	is_overlapping = true


func _on_body_exited(body: Node2D) -> void:
	if get_overlapping_bodies().is_empty():
		modulate.g = 1
		modulate.b = 1
		is_overlapping = false
