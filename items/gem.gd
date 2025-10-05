extends RigidBody2D

@export var collision_force : Vector2 = Vector2(2, 2)

signal gem_lost

func _on_body_entered(body: Node) -> void:
	var direction = (position - body.position).normalized()
	var impulse = direction*collision_force
	apply_central_impulse(impulse)

	if body.is_in_group("baddie"):
		if not body.has_gem:
			body.pick_up_gem()
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	gem_lost.emit()
	queue_free()
