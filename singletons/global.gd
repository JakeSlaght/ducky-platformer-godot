extends Node

enum PlayerState { SMALL, BIG, ACORN }
var current_state: PlayerState = PlayerState.SMALL
var twigs_total: int = 0

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

func spawn_twig(position: Vector2) -> void:
	var twig_scene = load("res://twig.tscn")
	var twig = twig_scene.instantiate()
	twig.global_position = position
	get_tree().root.add_child(twig)
	
func spawn_ring(position: Vector2) -> void:
	var rainbow_ring_scene = load("res://rainbow_ring.tscn")
	var rainbow_ring = rainbow_ring_scene.instantiate()
	rainbow_ring.global_position = position
	get_tree().root.add_child(rainbow_ring)


func add_duck_life() -> bool:
	var remaining_twigs = twigs_total - 100
	if remaining_twigs >= 0:
		twigs_total = remaining_twigs
		SignalBus.update_twigs_counter.emit(0)
		return true
	
	return false
