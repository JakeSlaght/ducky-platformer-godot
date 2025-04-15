extends Control
@onready var game: Node2D = %game
@onready var menus: CanvasLayer = %menus
@onready var hud: CanvasLayer = %hud

func _on_game_pressed() -> void:
	game.visible = true
	hud.visible = true
	menus.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()
