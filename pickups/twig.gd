extends Area2D

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		SignalBus.update_twigs_counter.emit(1)
		if Global.add_duck_life():
			body.add_life()
		queue_free()
