extends CharacterBody2D

@export var move_speed : int = 500

func get_input():
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _physics_process(_delta):
	var input_direction = get_input()
	velocity = input_direction*move_speed
	move_and_slide()
