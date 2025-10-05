extends CharacterBody2D

#TODO: handle damage

@export var move_speed : int = 200
@export var health : int = 3

@onready var gem = $Gem
@onready var sprite = $AnimatedSprite2D

var target_gem = null
var has_gem : bool = false

signal gem_stolen

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

func die_and_drop_gem():
	if has_gem:
		get_parent().replace_gem(global_position)
		queue_free()

func take_damage():
	health -= 1

	if health <= 0:
		die_and_drop_gem()

func pick_up_gem():
	has_gem = true
	gem.show()

func _ready():
	# get the nearest gem at spawn
	target_gem = find_nearest_gem()

func _physics_process(_delta):
	if not has_gem:
		if (is_instance_valid(target_gem)):
			velocity = global_position.direction_to(target_gem.get_global_position())*move_speed
		else:
			# find another gem to target
			target_gem = find_nearest_gem()

	if velocity.x > 0:
		sprite.flip_h = false
		gem.position.x = 10
	else:
		sprite.flip_h = true
		gem.position.x = -10

	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if has_gem:
		gem_stolen.emit()
		gem.hide()
		has_gem = false
		target_gem = find_nearest_gem()
