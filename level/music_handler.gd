extends Node2D

@export var intro : AudioStream
@export var loop : AudioStream

@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	var intro_length = intro.get_length()

	audio_player.stream = intro
	audio_player.play()

	while audio_player.playing:
		if audio_player.get_playback_position() >= intro_length:
			break
		await get_tree().process_frame

	audio_player.stream = loop
	audio_player.play()
