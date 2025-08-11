extends Node2D

enum TravisState { IDLE, WALK, WALK_JUG, DRINK }

@export var speed = 100

var action = "walk"
var direction := "south"

var jug = false
var drinking = false
var drink_timer := 0.0
var drink_duration := 0.0

var screen_size

var state: TravisState = TravisState.IDLE
var velocity = Vector2.ZERO

@onready var sprite := $TravisBody.get_node("AnimatedSprite2D")

func _ready() -> void:
	screen_size = get_viewport_rect().size
	jug = false

func get_jug() -> void:
	jug = true

func drop_jug() -> void:
	jug = false

func move_and_animate(delta: float) -> void:
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

func die() -> void:
	print("DYING")

func switch_jug() -> void:
	jug = !jug
	print("SWITCHING")
	if jug:
		sprite.animation = "walk_jug_%s" % [direction]
	else:
		sprite.animation = "walk_%s" % [direction]

	sprite.play()

func state_drink(delta: float) -> void:
	drink_timer += delta
	if drink_timer >= drink_duration:
		change_state(TravisState.IDLE)

func state_idle(_delta: float) -> void:
	if Input.is_action_just_pressed("action") && jug:
		change_state(TravisState.DRINK)
		return
	if Input.is_action_pressed("move_right"):
		direction = "east"
		change_state(TravisState.WALK)
	if Input.is_action_pressed("move_left"):
		direction = "west"
		change_state(TravisState.WALK)
	if Input.is_action_pressed("move_down"):
		direction = "south"
		change_state(TravisState.WALK)
	if Input.is_action_pressed("move_up"):
		direction = "north"
		change_state(TravisState.WALK)

func state_walk(delta: float) -> void:
	if Input.is_action_just_pressed("action") && jug:
		change_state(TravisState.DRINK)
		return
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		direction = "east"
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		direction = "west"
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		direction = "north"
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		direction = "south"
	if velocity.length() > 0:
		if !jug:
			change_state(TravisState.WALK)
		else:
			change_state(TravisState.WALK_JUG)
	else:
		change_state(TravisState.IDLE)
		return
	$TravisBody.velocity = velocity
	$TravisBody.move_and_slide()
	position += velocity * delta * speed

func _process(delta: float) -> void:
	match state:
		TravisState.IDLE:
			state_idle(delta)
		TravisState.WALK:
			state_walk(delta)
		TravisState.WALK_JUG:
			state_walk(delta)
		TravisState.DRINK:
			state_drink(delta)

func change_state(new_state: TravisState) -> void:
	state = new_state
	match state:
		TravisState.IDLE:
			sprite.stop()
		TravisState.WALK:
			sprite.play("walk_%s" % direction)
		TravisState.WALK_JUG:
			sprite.play("walk_jug_%s" % direction)
		TravisState.DRINK:
			var anim_name = "drink_%s" % direction
			sprite.play(anim_name)
			drink_timer = 0.0
			drink_duration = get_anim_length(anim_name)

func get_anim_length(anim_name: String) -> float:
	var frames = sprite.sprite_frames.get_frame_count(anim_name)
	var fps = sprite.sprite_frames.get_animation_speed(anim_name)
	return frames / fps
