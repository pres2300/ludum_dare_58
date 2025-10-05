extends Node2D

@export var current_level : int = 1
@export var gem_node : PackedScene
@export var baddie_node : PackedScene

@onready var hud = $HUD
@onready var next_level_timer = $NextLevelTimer
@onready var gems_list = $GemsList
@onready var baddie_list = $BaddieList
@onready var spawn_locations = $SpawnLocations

var num_gems : int
var level_active : bool = true
var max_level : int

func replace_gem(location : Vector2) -> void:
	var new_gem = gem_node.instantiate()
	new_gem.position = location
	add_child(new_gem)
	new_gem.gem_lost.connect(_gem_lost)

func setup_next_level() -> void:
	current_level += 1
	hud.set_level(current_level)
	hud.set_countdown(5)
	hud.show_countdown()
	next_level_timer.start(5.0)

func spawn_baddies() -> void:
	# List of spawn locations to keep track and not spawn baddies on top of each other
	var locations = spawn_locations.get_children()

	for i in range(current_level):
		var new_baddie = baddie_node.instantiate()

		# index to spawn into
		var index = randi_range(0, locations.size()-1)

		var spawn_location : Vector2 = locations[index].global_position

		locations.remove_at(index)

		new_baddie.global_position = spawn_location
		new_baddie.gem_stolen.connect(_gem_lost)
		baddie_list.add_child(new_baddie)

func _process(_delta: float) -> void:
	if $BaddieList.get_child_count() == 0 and level_active:
		level_active = false
		setup_next_level()
	else:
		var time_left : int = int(next_level_timer.get_time_left() + 0.5)
		hud.set_countdown(time_left)

	if num_gems <= 0:
		print("game over")

func _ready():
	hud.set_level(current_level)
	max_level = spawn_locations.get_child_count()
	num_gems = gems_list.get_child_count()

	for gem in gems_list.get_children():
		gem.gem_lost.connect(_gem_lost)

func _on_next_level_timer_timeout() -> void:
	hud.hide_countdown()
	spawn_baddies()
	level_active = true

func _gem_lost() -> void:
	num_gems -= 1
