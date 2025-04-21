class_name Enemy extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = %sprite
@export var current_map: Map

const SPEED:float = 25.0
var tile_position: Vector2i
var direction:Vector2 = Vector2.LEFT
var is_alive: bool = true

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		
		if collision:
			var new_direction = direction
			while new_direction == direction:
				new_direction  = change_direction()
			
			direction = new_direction
			sprite.flip_h = !sprite.flip_h

func change_direction() -> Vector2:
	var directions = [Vector2.LEFT, Vector2.RIGHT] # [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	return directions[randi() % directions.size()]

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		print_debug('test')
		is_alive = false
		queue_free()
