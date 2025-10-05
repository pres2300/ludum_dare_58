extends CharacterBody2D

@export var projectile_scene : PackedScene
@export var move_speed : int = 350
@export var shooting_cooldown : float = 1.0

@onready var sprite = $AnimatedSprite2D
@onready var shooting_cooldown_timer = $ShootingCooldownTimer
@onready var gem = $Gem

var is_shooting_cooldown : bool = false
var has_gem : bool = false

func get_movement_input():
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func pick_up_gem():
	has_gem = true
	gem.show()

func drop_gem():
	if has_gem:
		has_gem = false
		gem.hide()

		var gem_position : Vector2 = global_position
		if sprite.flip_h:
			gem_position.x -= 25
		else:
			gem_position.x += 25

		get_parent().replace_gem(gem_position)

func attack():
	if is_shooting_cooldown or has_gem:
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
	#$AttackSound.play()
	shooting_cooldown_timer.start(shooting_cooldown)

func _process(_delta):
	if Input.is_action_pressed("attack"):
		attack()

	if Input.is_action_pressed("drop_gem"):
		drop_gem()

func _physics_process(_delta: float) -> void:
	var input_direction = get_movement_input()
	velocity = input_direction*move_speed

	if abs(velocity.x) > 0 or abs(velocity.y) > 0:
		sprite.play("walking")

		if velocity.x > 0:
			sprite.flip_h = false
			gem.position.x = 19
		else:
			sprite.flip_h = true
			gem.position.x = -19
	else:
		sprite.play("idle")

	move_and_slide()

func _on_shooting_cooldown_timer_timeout() -> void:
	is_shooting_cooldown = false
