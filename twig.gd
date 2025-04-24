extends Area2D

func _on_hitbox_body_entered(body: Node2D) -> void:
	SignalBus.update_twigs_counter.emit(1)
	queue_free()
	
