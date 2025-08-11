extends Node2D

enum TravisState {
	IDLE,
	WALKING,
	DRINKING,
	DYING
}

@export var speed = 100

var action = "walk"
var direction = "south"

var jug = true

var screen_size

var state = TravisState.IDLE
var velocity = Vector2.ZERO

func _ready() -> void:
	screen_size = get_viewport_rect().size

func get_jug() -> void:
	jug = true

func drop_jug() -> void:
	jug = false

func update_state() -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		state = TravisState.WALKING
	else:
		state = TravisState.IDLE

func move_and_animate(delta: float) -> void:
	var sprite = $TravisBody.get_node("AnimatedSprite2D")
	if velocity.x > 0:
		direction = "east"
	if velocity.x < 0:
		direction = "west"
	if velocity.y > 0:
		direction = "south"
	if velocity.y < 0:
		direction = "north"

	if jug:
		action = "walk_jug"
	else:
		action = "walk"

	sprite.animation = "%s_%s" % [action, direction]

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		sprite.play()
	else:
		sprite.stop()

	$TravisBody.velocity = velocity
	$TravisBody.move_and_slide()
	position += velocity * delta

func switch_jug() -> void:
	jug = !jug
	var sprite = $TravisBody.get_node("AnimatedSprite2D")

	if jug:
		sprite.animation = "walk_jug_%s" % [direction]
	else:
		sprite.animation = "walk_%s" % [direction]

	sprite.play()

func _process(delta: float) -> void:
	update_state()
	move_and_animate(delta)
