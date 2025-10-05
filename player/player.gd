extends CharacterBody2D

@export var projectile_scene : PackedScene
@export var move_speed : int = 350
@export var shooting_cooldown : float = 0.5

@onready var sprite = $AnimatedSprite2D
@onready var shooting_cooldown_timer = $ShootingCooldownTimer
@onready var shooting_sound = $AudioStreamPlayer2D

var is_shooting_cooldown : bool = false

func get_movement_input():
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func attack():
	if is_shooting_cooldown:
		return

	is_shooting_cooldown = true
	var b = projectile_scene.instantiate()
	get_tree().root.add_child(b)
	var dir = global_position.direction_to(get_global_mouse_position())
	$MouthLocation.rotation = dir.angle()

	# Compensate for direction
	if sprite.flip_h:
		$MouthLocation.position.x = -12
	else:
		$MouthLocation.position.x = 12

	b.start($MouthLocation.global_transform)
	shooting_sound.play()
	shooting_cooldown_timer.start(shooting_cooldown)

func _process(_delta):
	if Input.is_action_pressed("attack"):
		attack()

func _physics_process(_delta: float) -> void:
	var input_direction = get_movement_input()
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

func _on_shooting_cooldown_timer_timeout() -> void:
	is_shooting_cooldown = false
