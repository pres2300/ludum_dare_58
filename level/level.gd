extends Node2D

@export var current_level : int = 1
@export var gem_node : PackedScene
@export var baddie_node : PackedScene

#TODO: Add gem handler (end game when all lost)
#TODO: Add baddie spawner (more difficult over time)

func spawn_gem(location : Vector2) -> void:
	var new_gem = gem_node.instantiate()
	new_gem.position = location
	add_child(new_gem)
