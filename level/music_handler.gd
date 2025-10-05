extends Node2D

@export var title : AudioStream
@export var intro : AudioStream
@export var loop : AudioStream

@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

func switch_to_main_audio() -> void:
	var title_length = title.get_length()

	# for whatever reason, the intro loop doesn't detect at max title_length, but /2 seems to work :/
	while audio_player.playing:
		if audio_player.get_playback_position() < title_length/2.0:
			break
		await get_tree().process_frame

	var intro_length = intro.get_length()

	audio_player.stream = intro
	audio_player.play()

	while audio_player.playing:
		if audio_player.get_playback_position() >= intro_length:
			break
		await get_tree().process_frame

	audio_player.stream = loop
	audio_player.play()

func switch_to_title_audio() -> void:
	var main_length = loop.get_length()

	while audio_player.playing:
		if audio_player.get_playback_position() < main_length/2.0:
			break
		await get_tree().process_frame

	audio_player.stream = title
	audio_player.play()

func _ready():
	audio_player.stream = title
	audio_player.play()
