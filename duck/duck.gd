class_name Duck extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var death_timer: Timer = %death_timer
@onready var acorn_firing_timer: Timer = %acorn_firing_timer
@onready var immortal_timer: Timer = %immortal_timer

@export var immortal_shader: ShaderMaterial
@export var current_map: String
@export var immortality_duration : float = 5.0  # The duration of the color shift effect

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
var is_invincibile: bool = false

func _ready() -> void:
	become_immortal()
	SignalBus.update_lives_counter.emit(lives)
	death_timer.connect('timeout', Callable(self, 'death_timeout'))
	acorn_firing_timer.connect('timeout', Callable(self, 'firing_timeout'))
	immortal_timer.connect('timeout', Callable(self, 'immortal_timeout'))
	animated_sprite_2d.flip_h = false

func _physics_process(delta: float) -> void:
	if is_dying:
		return

	if is_invincibile:
		_immortality_processing(delta)

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

	## TODO: Create a jump animation for duck!
	## TODO: Create animations for acorn variants
	match Global.current_state:
		Global.PlayerState.SMALL, Global.PlayerState.BIG:
			if is_jumping:
				animated_sprite_2d.play('jump')
			elif direction != 0:
				animated_sprite_2d.play('run')
			else: #idle
				animated_sprite_2d.play('idle')
		Global.PlayerState.ACORN:
			if is_jumping:
				animated_sprite_2d.play('acorn_jump')
			elif direction != 0:
				animated_sprite_2d.play('acorn_run')
			else: #idle
				animated_sprite_2d.play('acorn_idle')

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
	if body.is_in_group("enemies") and body.is_alive and not is_invincibile:
		match Global.current_state:
			Global.PlayerState.SMALL:
				_handle_health()
			Global.PlayerState.BIG, Global.PlayerState.ACORN:
				become_small()
			#Global.PlayerState.ACORN:
				#Global.current_state = Global.PlayerState. BIG

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
	
func become_immortal() -> void:
	is_invincibile = true
	#immortal_timer.wait_time = 0.1
	immortal_timer.start()
	animated_sprite_2d.set_material(immortal_shader)
	immortal_shader.set_shader_parameter('time_duration', immortality_duration)
	immortal_shader.set_shader_parameter('time_passed', 0.0)

func _immortality_processing(delta: float) -> void:
	var time_passed = immortal_shader.get_shader_parameter('time_passed')
	time_passed += (delta/immortality_duration) * 5.0

	if time_passed > 1.0:
		time_passed -= 1.0 #ensures that the time pass doesn't go over 1
	
	immortal_shader.set_shader_parameter('time_passed', time_passed)

func immortal_timeout() -> void:
	immortal_timer.stop()
	immortal_shader.set_shader_parameter('time_passed', 0.0)
	is_invincibile = false
	animated_sprite_2d.set_material(null)

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
