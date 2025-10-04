extends CharacterBody2D

@export var move_speed : int = 200
@export var health : int = 3

var target_gem = null

func find_nearest_gem():
	var possible_targets = get_tree().get_nodes_in_group("gem")

	if (possible_targets.size() == 0):
		# no gems found
		return null

	var min_target_dist : float = global_position.distance_squared_to(possible_targets[0].global_position)
	var nearest_gem = possible_targets[0]

	for target in possible_targets:
		if global_position.distance_squared_to(target.global_position) < min_target_dist:
			nearest_gem = target

	return nearest_gem

func _ready():
	# get the nearest gem at spawn
	target_gem = find_nearest_gem()

func _physics_process(_delta):
	if (is_instance_valid(target_gem)):
		velocity = global_position.direction_to(target_gem.get_global_position())*move_speed
	else:
		# find another gem to target
		target_gem = find_nearest_gem()

	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
