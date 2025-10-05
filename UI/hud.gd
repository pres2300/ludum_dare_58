extends CanvasLayer

@onready var current_level = $Control/MarginContainer/HBoxContainer/CurrentLevel
@onready var countdown = $Control/Countdown
@onready var countdown_value = $Control/Countdown/HBoxContainer/Countdown
@onready var paused = $Control/MarginContainer2/Paused

func set_level(num : int):
	current_level.text = str(num)

func show_countdown():
	countdown.show()

func hide_countdown():
	countdown.hide()

func set_countdown(num: int):
	countdown_value.text = str(num)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			paused.show()
		else:
			paused.hide()
