class_name Buzzsaw extends Area2D
var is_alive: bool = true


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		is_alive = false
		queue_free()
