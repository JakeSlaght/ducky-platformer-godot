class_name Platform extends Node2D

@export var direction: int = 0 # 0 = left to right, 1 = up to down
@export var looping: bool = true # true means it loops back and forth
@export var respawn_at_start: bool = false # false for looping is true, if false and looping is false need to setup timer for disappearing
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	var animation_name: String = ''
	if direction == 1:
		animation_name = 'up_and_down'
	elif direction == 0:
		animation_name = 'left_to_right'
	
	if animation_name:
		var animation: Animation = animation_player.get_animation(animation_name)
		if looping:
			animation.loop_mode = Animation.LOOP_PINGPONG
		elif respawn_at_start:
			animation.loop_mode = Animation.LOOP_LINEAR
		else:
			animation.loop_mode = Animation.LOOP_NONE
		
		animation_player.play(animation_name)
