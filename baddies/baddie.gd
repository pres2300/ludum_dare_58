extends CharacterBody2D

#TODO: play damaged sound

@export var move_speed : int = 200
@export var health : int = 1

@onready var gem = $Gem
@onready var sprite = $AnimatedSprite2D
@onready var gem_stolen_sound = $GemStolenSound

var target_gem = null
var has_gem : bool = false
var dying : bool = false

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
		has_gem = false
		get_tree().get_first_node_in_group("level").replace_gem(global_position)
		gem.hide()

	$DieSound.play()
	await $DieSound.finished

	queue_free()

func take_damage():
	if dying:
		return

	health -= 1

	if health <= 0:
		dying = true
		die_and_drop_gem()

func pick_up_gem():
	has_gem = true
	gem.show()

func _ready():
	# get the nearest gem at spawn
	target_gem = find_nearest_gem()

func _physics_process(_delta):
	if dying:
		return

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
		gem_stolen_sound.play()
		gem.hide()
		has_gem = false
		target_gem = find_nearest_gem()
