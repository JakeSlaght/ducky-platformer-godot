extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		Global.current_state = Global.PlayerState.ACORN
		self.queue_free()
