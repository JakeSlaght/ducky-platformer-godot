extends Camera2D

@export var player: Duck

@onready var window_size = Vector2(DisplayServer.window_get_size())
@onready var player_world_pos = get_player_world_pos()

func _ready():
	calculate_and_set_camera_transform()

func calculate_and_set_camera_transform() -> void:
	var canvas_transform = get_viewport().get_canvas_transform()
	canvas_transform[2] = player_world_pos * window_size
	get_viewport().set_canvas_transform(canvas_transform)
	
func get_player_world_pos():
	# Converts the player position to the map he's on. Returns the map id/coordinates as Vector2
	var pos = player.get_position()
	var x = floor(pos.x / window_size.x)
	var y = floor(pos.y / window_size.y)
	return Vector2(x, y)


# This is a basic solution to the problem. Another way would be to divide the world using a grid
# and to check on which cell the player is. With each map containing the same amount of cells,
# we can calculate where the player is in the world
# (hint: the tileset we use for the background is a grid!)
func _physics_process(delta: float):
	# Checks if the player is touching or moved beyond the view rectangle's edges
	# If so, offset the camera in this direction
	var new_player_world_pos = get_player_world_pos()

	if new_player_world_pos != player_world_pos:
		player_world_pos = -new_player_world_pos
		calculate_and_set_camera_transform()
