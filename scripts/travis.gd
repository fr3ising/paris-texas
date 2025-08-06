extends Node2D

@export var speed = 100
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(_delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	var sprite = $TravisBody.get_node("AnimatedSprite2D")
	if velocity.x > 0:
		sprite.animation = "walk_east"
	if velocity.x < 0:
		sprite.animation = "walk_west"
	if velocity.y > 0:
		sprite.animation = "walk_south"
	if velocity.y < 0:
		sprite.animation = "walk_north"

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		sprite.play()
	else:
		sprite.stop()
	$TravisBody.velocity = velocity
	$TravisBody.move_and_slide()
	position += velocity * _delta
	# position = $TravisBody.position
	# position = position.clamp(Vector2.ZERO, screen_size)
