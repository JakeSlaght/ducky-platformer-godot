class_name Slug extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = %sprite
@export var current_map: Map

const SPEED:float = 25.0
var tile_position: Vector2i
var direction: int = -1
var is_alive: bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = direction * SPEED
	
	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		is_alive = false
		queue_free()
