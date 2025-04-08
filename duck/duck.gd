class_name Duck extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
#@onready var game: Node2D = %game
#@onready var menus: CanvasLayer = %menus
@export var current_map: Map

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
var double_jump:bool = false
var tile_position: Vector2i

func _physics_process(delta: float) -> void:
	_collision_check(delta)

	var direction := Input.get_axis("left", "right")
	#tile_position = current_map.player_to_tile_location(global_position)
	
	animated_sprite_2d.flip_h = velocity.x < 0
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	_jump()

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _jump() -> void:
		# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		double_jump = !double_jump
		
	# Handle double jump
	if Input.is_action_just_pressed("jump") and !is_on_floor():
		if double_jump:
			velocity.y = JUMP_VELOCITY
			double_jump = !double_jump
	# TODO: Handle wall jump...
	#if is_on_wall():
		#if Input.is_action_just_pressed("wall_jump"):
			#velocity.x = -direction * SPEED
			#velocity.y = JUMP_VELOCITY
			#animated_sprite_2d.flip_h = velocity.x < 0
			#move_and_slide()

func _collision_check(delta) -> void:
	pass
	#var collision_info = move_and_collide(velocity * delta)
	#if collision_info:
		#var collider = collision_info.get_collider()
#
		#if collider.name == 'pitfall':
			#print_debug(collider.position)
			#print_debug('you dead', '(x, y): (', position.x, ',', position.y, ')', velocity)
			##position = Vector2i(32,0)
			##game.visible = falsed
			##menus.visible = true
		##if collider.name == 'platform':
			##print_debug(collider)
			###print_debug(collider.velocity)
			###print_debug(collider.get_collider_velocity())
			###print_debug(get_platform_velocity())
