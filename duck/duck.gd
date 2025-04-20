class_name Duck extends CharacterBody2D

@onready var death_timer: Timer = %death_timer
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@export var current_map: String

const SPEED = 450.0
const JUMP_VELOCITY = -450.0
var double_jump:bool = false
var tile_position: Vector2i
var lives: int = 3
var is_dying:bool = false
var is_big: bool = false

func _ready() -> void:
	SignalBus.update_lives_counter.emit(lives)
	death_timer.connect('timeout', Callable(self, 'death_timeout'))

func _physics_process(delta: float) -> void:
	if is_dying:
		return

	var direction := Input.get_axis("left", "right")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	_jump()

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	animated_sprite_2d.flip_h = velocity.x < 0

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

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and body.is_alive:
		if is_big:
			become_small()
		else:
			_handle_health()

func _handle_health() -> void:
	var updated_lives = lives - 1
	if updated_lives > 0:
		lives = updated_lives
		Loader.create_new_game(self)
		die()
	else:
		lives = 0
		die()
		
	if lives > 0:
		print_debug('need to reload the current level')
		Loader.load_game()
		get_tree().reload_current_scene()
	else:
		print_debug('create a you died menu')

func die() -> void:
	if is_dying:
		return
	
	is_dying = true
	animated_sprite_2d.play('die')
	SignalBus.update_lives_counter.emit(lives)

func death_timeout() -> void:
	#get_tree().reload_current_scene()
	pass

func become_big() -> void:
	is_big = true
	self.scale = Vector2(1.5, 1.5)

func become_small() -> void:
	is_big = false
	self.scale = Vector2(1, 1)


func _on_feet_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and body.is_alive:
		velocity.y = JUMP_VELOCITY
