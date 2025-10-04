extends RigidBody2D

@export var collision_force : Vector2 = Vector2(2, 2)

var picked_up : bool = false

signal taken

func _on_body_entered(body: Node) -> void:
	var direction = (position - body.position).normalized()
	var impulse = direction*collision_force
	apply_central_impulse(impulse)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	taken.emit()
	queue_free()
