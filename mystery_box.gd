extends Area2D
@onready var sprite_2d: Sprite2D = %Sprite2D

enum State { UNBUMPED, BUMPED }
var state: State = State.UNBUMPED
var original_position: Vector2

func _ready() -> void:
	original_position = position

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player') and state == State.UNBUMPED:
		_bump_block()
		
func _bump_block() -> void:
	state = State.BUMPED
	sprite_2d.frame = 1

	var rando_drop = randf()
	if rando_drop < 0.3:
		Global.spawn_ring(self.global_position + Vector2(0,-30))
	else:
		match Global.current_state:
			Global.PlayerState.SMALL:
				Global.spawn_bread(self.global_position + Vector2(0, -20))
			Global.PlayerState.BIG, Global.PlayerState.ACORN:
				Global.spawn_acorn(self.global_position + Vector2(0, -30))
			_:
				Global.spawn_twig(self.global_position + Vector2(0,-30))

	_bump_upwards()
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	_return_to_original_position()
	
func _bump_upwards() -> void:
	position.y -= 10

func _return_to_original_position() -> void:
	position = original_position
