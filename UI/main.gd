extends Node

@export var level_scene : PackedScene

@onready var title_screen = $TitleScreen
@onready var start_button = $TitleScreen/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/StartButton
@onready var music_handler = $MusicHandler

func _on_start_button_pressed() -> void:
	print("start pressed")
	music_handler.switch_to_main_audio()
	var level = level_scene.instantiate()
	add_child(level)
	title_screen.queue_free()
