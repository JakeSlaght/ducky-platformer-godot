extends Node

func spawn_bread(position: Vector2) -> void:
	var load_of_bread_scene = load("res://load_of_bread.tscn")
	var loaf_of_bread = load_of_bread_scene.instantiate()
	loaf_of_bread.global_position = position
	get_tree().root.add_child(loaf_of_bread)
