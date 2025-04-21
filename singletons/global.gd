extends Node

enum PlayerState { SMALL, BIG, ACORN }
var current_state: PlayerState = PlayerState.SMALL

func spawn_bread(position: Vector2) -> void:
	var load_of_bread_scene = load("res://load_of_bread.tscn")
	var loaf_of_bread = load_of_bread_scene.instantiate()
	loaf_of_bread.global_position = position
	get_tree().root.add_child(loaf_of_bread)

func spawn_acorn(position: Vector2) -> void:
	var acorn_powerup_scene = load("res://acorn_powerup.tscn")
	var acorn_powerup = acorn_powerup_scene.instantiate()
	acorn_powerup.global_position = position
	get_tree().root.add_child(acorn_powerup)
