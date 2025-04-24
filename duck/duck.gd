class_name Duck extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var death_timer: Timer = %death_timer
@onready var acorn_firing_timer: Timer = %acorn_firing_timer

@export var current_map: String

const SPEED: float = 450.0
const JUMP_VELOCITY: float = -450.0
var tile_position: Vector2i
var lives: int = 3
var player_direction: int = 1

var double_jump:bool = false
var is_dying:bool = false
var is_big: bool = false
var is_firing_acorn: bool = false
var can_fire_acorn: bool = false
var is_jumping: bool = false

func _ready() -> void:
	SignalBus.update_lives_counter.emit(lives)
	death_timer.connect('timeout', Callable(self, 'death_timeout'))
	acorn_firing_timer.connect('timeout', Callable(self, 'firing_timeout'))
	animated_sprite_2d.flip_h = false
	
func _physics_process(delta: float) -> void:
	if is_dying:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction: float = Input.get_axis("left", "right")
	if direction < 0:
		animated_sprite_2d.flip_h = true
		player_direction = -1
	else:
		animated_sprite_2d.flip_h = false
		player_direction = 1

	if Global.current_state == Global.PlayerState.ACORN and Input.is_action_just_pressed('fire'):
		_fire_acorn()

	_jump()

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_update_animation(direction)
	move_and_slide()

func _update_animation(direction: float) -> void:
	if is_dying or is_firing_acorn:
		return

	## TODO: Create an idle and jump animation for duck!
	## TODO: Create animations for acorn variants
	match Global.current_state:
		Global.PlayerState.SMALL, Global.PlayerState.BIG:
			if is_jumping:
				pass
			elif direction != 0:
				animated_sprite_2d.play('run')
			else: #idle
				animated_sprite_2d.play('idle')
		Global.PlayerState.ACORN:
			if is_jumping:
				pass
			elif direction != 0:
				animated_sprite_2d.play('run')
			else: #idle
				animated_sprite_2d.play('idle')

func _jump() -> void:
		# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		is_jumping = true
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
		match Global.current_state:
			Global.PlayerState.SMALL:
				_handle_health()
			Global.PlayerState.BIG:
				Global.current_state = Global.PlayerState.SMALL
			Global.PlayerState.ACORN:
				Global.current_state = Global.PlayerState. BIG

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

func add_life() -> void:
	var updated_life = lives + 1
	lives = updated_life
	SignalBus.update_lives_counter.emit(lives)

func become_big() -> void:
	Global.current_state = Global.PlayerState.BIG
	self.scale = Vector2(1.5, 1.5)

func become_small() -> void:
	Global.current_state = Global.PlayerState.SMALL
	self.scale = Vector2(1, 1)
	
func got_acorn() -> void:
	Global.current_state = Global.PlayerState.ACORN

func _on_feet_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and body.is_alive:
		velocity.y = JUMP_VELOCITY

func _fire_acorn() -> void:
	is_firing_acorn = true
	var acorn = load("res://acorn.tscn").instantiate()
	acorn.global_position = Vector2(self.global_position.x, self.global_position.y - 15)
	acorn.set('velocity', Vector2(500 * player_direction, 0))
	get_parent().add_child(acorn)
	##TODO: create acorn firing
	#animated_sprite_2d.play('acorn_fire')
	acorn_firing_timer.start(1.0)

func firing_timeout() -> void:
	is_firing_acorn = false
