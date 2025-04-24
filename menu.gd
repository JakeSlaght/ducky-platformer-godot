extends Control
@onready var game: Node2D = %game
@onready var menus: CanvasLayer = %menus
@onready var hud: CanvasLayer = %hud

var game_data: GameData
var duck_scene = load("res://duck/duck.tscn")
var map_scene = load("res://map_logics/map.tscn")
var camera_scene = load("res://camera.tscn")
var map: Map
var duck: Duck

func _ready() -> void:
	game.visible = false
	hud.visible = false
	menus.visible = true

func _on_game_pressed() -> void:
	game_data = Loader.load_game()
	if !game_data:
		_start_new_game()

	_load_game(game_data)
	SignalBus.update_twigs_counter.emit(0)
	game.visible = true
	hud.visible = true
	menus.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _load_game(game_data: GameData) -> void:
	if !map:
		map = map_scene.instantiate()
		game.add_child(map)
	
	if !duck:
		duck = duck_scene.instantiate()
		game.add_child(duck)

	duck.lives = game_data.STARTING_LIVES + game_data.adjust_lives
	duck.current_map = game_data.level_name
	map.map_name = 'test'
	map.duck = duck
	
	map.generate_map()
	
	SignalBus.update_lives_counter.emit(duck.lives)


func _start_new_game() -> void:
	game_data = GameData.new()
	map = map_scene.instantiate()
	duck = duck_scene.instantiate()

	game.add_child(map)
	game.add_child(duck)
	
	duck.current_map = 'test'
	map.map_name = 'test'
	map.duck = duck
	
	map.generate_map()
	
	Loader.create_new_game(duck)
