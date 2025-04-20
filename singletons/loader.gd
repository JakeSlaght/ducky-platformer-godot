extends Node

const DIR_PATH = 'user://ducklings'

static func create_new_game(duck: Duck) -> void:
	var save_path = '%s/save.tres' %[DIR_PATH]
	var game: GameData = GameData.new()
	
	game.level_name = duck.current_map
	game.adjust_lives = duck.lives - game.STARTING_LIVES
	
	ResourceSaver.save(game,save_path)

static func load_game() -> GameData:
	var game: GameData
	var game_path = '%s/save.tres' %[DIR_PATH]
	game = load(game_path) as GameData
	
	return game
