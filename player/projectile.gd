extends Area2D

@export var speed = 1000

var velocity = Vector2.ZERO

func start(_transform):
	# Only get the origin and rotation of the _transform to avoid scale issues
	position = _transform.get_origin()
	rotation = _transform.get_rotation()
	velocity = (transform.x/transform.get_scale().x)*speed

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _process(delta):
	position += velocity*delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	body.take_damage()
	queue_free()
