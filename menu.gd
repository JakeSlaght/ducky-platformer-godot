extends Control
@onready var game: Node2D = %game
@onready var menus: CanvasLayer = %menus

func _on_game_pressed() -> void:
	game.visible = true
	menus.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()
