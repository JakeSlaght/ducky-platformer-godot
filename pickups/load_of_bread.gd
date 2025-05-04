extends CharacterBody2D

var speed: int = 30
var direction: int = -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.y += gravity * delta
	velocity.x = direction * speed

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body.become_big()
		queue_free()
	else:
		direction *= -1
