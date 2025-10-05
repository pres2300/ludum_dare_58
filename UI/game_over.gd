extends Control

signal try_again

func set_wave(wave) -> void:
	$MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/WaveReached.text = str(wave)

func _on_start_button_pressed() -> void:
	try_again.emit()
