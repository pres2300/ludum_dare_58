extends CharacterBody2D

#TODO: shoot projectiles

@export var move_speed : int = 350

@onready var sprite = $AnimatedSprite2D

func get_input():
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _physics_process(_delta: float) -> void:
	var input_direction = get_input()
	velocity = input_direction*move_speed

	if abs(velocity.x) > 0 or abs(velocity.y) > 0:
		sprite.play("walking")

		if velocity.x > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	else:
		sprite.play("idle")

	move_and_slide()
