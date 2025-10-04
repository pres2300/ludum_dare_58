extends RigidBody2D

@export var collision_force : Vector2 = Vector2(2, 2)

func _on_body_entered(body: Node) -> void:
	var direction = (position - body.position).normalized()
	apply_central_impulse(direction*collision_force)
	print("applied impulse: ", direction*Vector2(200,200))
