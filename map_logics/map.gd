class_name Map extends Node2D

@export var duck: Duck
@export var map_name: String
@export var colors: PackedColorArray
@export var camera: Camera2D
@onready var water: TileMapLayer = %water

var platform_scene = load("res://map_logics/platform.tscn")
var level_end_scene = load("res://level_ending.tscn")
var slug_scene = load("res://enemy/slug.tscn")
var mystery_box_scene = load("res://pickups/mystery_box.tscn")
var twig_scene = load("res://pickups/twig.tscn")
var buzzsaw_scene = load("res://enemy/buzzsaw.tscn")

var TILE_SIZE: int = 32

var source_id: int = 3
var width: int
var height: int
var pit_width: int
var pit_height: int
var grass_tiles = [];
var map_path: String
var map: Image

func generate_map() -> void:
	map_path = 'res://images/%s.png' %[map_name]
	map = Image.load_from_file(map_path)
	width = map.get_width()
	height = map.get_height()

	for x in range(width):
		for y in range(height):
			generate_tile_from_pixel_coordinates(x,y)
	
	water.set_cells_terrain_connect(grass_tiles,source_id,0)

func generate_tile_from_pixel_coordinates(x: int, y: int) -> void:
	var pixelColor = map.get_pixel(x,y)
	if pixelColor.a == 0:
		return

	for item in colors.size(): #[blue, green, red, black]
		if colors[item].to_html(false) == pixelColor.to_html(false):
			match item:
				0: #blue - water
					water.set_cell(Vector2i(x,y), source_id, Vector2i(0,0), 0)
				1: #green - grass
					grass_tiles.append(Vector2i(x,y))
				2: #red - dirt
					water.set_cell(Vector2i(x,y), source_id, Vector2i(1,0),0)
				3: #black - enemies
					var new_slug = slug_scene.instantiate()
					new_slug.global_position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
					add_child(new_slug)
				4: #gray(128) - wall
					water.set_cell(Vector2i(x,y),source_id, Vector2i(4,0),0)
				5: #green(155) - left-to-right platforms
					var new_platform = platform_scene.instantiate()
					new_platform.direction = 0
					#new_platform.looping = false
					new_platform.global_position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
					new_platform.scale = Vector2(2,2)
					add_child(new_platform)
				6: #green(80) - up-to-down platforms
					var new_platform = platform_scene.instantiate()
					new_platform.direction = 1
					#new_platform.looping = false
					new_platform.global_position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
					new_platform.scale = Vector2(2,2)
					add_child(new_platform)
				7: #baby blue(89CFF0) - level end marker
					var level_end = level_end_scene.instantiate()
					level_end.scale = Vector2(2,2)
					level_end.global_position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
					add_child(level_end)
				8: #white - player
					duck.global_position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
				9: #gray(56) - mystery box
					var new_box = mystery_box_scene.instantiate()
					new_box.global_position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
					add_child(new_box)
				10: #greenish (74,76,38) - coins
					var new_twig = twig_scene.instantiate()
					new_twig.global_position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
					add_child(new_twig)
				11: #darkread (81,0,9) - buzzsaw flower
					var new_buzzsaw = buzzsaw_scene.instantiate()
					new_buzzsaw.global_position = Vector2(x*TILE_SIZE, y * TILE_SIZE)
					add_child(new_buzzsaw)

func player_to_tile_location(player_position: Vector2) -> Vector2i:
	var tile_x = int(player_position.x / width)
	var tile_y = int(player_position.y / height)

	return Vector2i(tile_x, tile_y)
	
func check_custom_tile_data_from_player(tile_location: Vector2i, _custom_data_tag: String) -> void:
	var tile = water.get_cell_tile_data(tile_location)
	if tile:
		pass

func reset_map() -> void:
	water.clear()
