extends Control

signal try_again

func _on_start_button_pressed() -> void:
	try_again.emit()
