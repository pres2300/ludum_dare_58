extends Node

@export var level_scene : PackedScene
@export var game_over_scene : PackedScene
@export var game_won_scene : PackedScene

@onready var title_screen = $TitleScreen
@onready var start_button = $TitleScreen/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/StartButton
@onready var music_handler = $MusicHandler

var game_over = null
var game_won = null
var level = null

func _game_won() -> void:
	music_handler.switch_to_title_audio()
	game_won = game_won_scene.instantiate()
	add_child(game_won)
	game_won.try_again.connect(_retry)
	level.queue_free()

func _retry() -> void:
	music_handler.switch_to_main_audio()
	level = level_scene.instantiate()
	add_child(level)
	level.game_over.connect(_game_over)
	level.game_won.connect(_game_won)

	if is_instance_valid(game_over):
		game_over.queue_free()

	if is_instance_valid(game_won):
		game_won.queue_free()

func _game_over(wave) -> void:
	music_handler.switch_to_title_audio()
	game_over = game_over_scene.instantiate()
	add_child(game_over)
	game_over.set_wave(wave)
	game_over.try_again.connect(_retry)
	level.queue_free()

func _on_start_button_pressed() -> void:
	music_handler.switch_to_main_audio()
	level = level_scene.instantiate()
	add_child(level)
	level.game_over.connect(_game_over)
	level.game_won.connect(_game_won)
	title_screen.queue_free()
