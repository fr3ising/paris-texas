extends Node2D

var TravisScene := preload("res://scenes/travis.tscn")
var DesertScene := preload("res://scenes/desert.tscn")
var HudScene := preload("res://scenes/hud.tscn")
var InventoryScene := preload("res://scenes/inventory_ui.tscn")

var travis
var camera
var timer
var inventory
var init_health = 50.0
var time_to_die = 20.0
var health_bar

func _ready() -> void:
	var desert = DesertScene.instantiate()
	add_child(desert)
	var hud = HudScene.instantiate()
	add_child(hud)
	health_bar = hud.get_node("HealthBar")
	health_bar.value = init_health
	_setup_timer()
	var travis_spawn_point = desert.get_node("TravisSpawnPoint")
	travis = TravisScene.instantiate()
	travis.global_position = travis_spawn_point.global_position
	add_child(travis)
	var travis_body = travis.get_node("TravisBody")
	camera = Camera2D.new()
	travis_body.add_child(camera)
	camera.make_current()
	camera.position_smoothing_enabled = false
	inventory = InventoryScene.instantiate()
	inventory.setup(on_click_bottle)
	add_child(inventory)

func on_click_bottle() -> void:
	timer.paused = false
	travis.switch_jug()

func _setup_timer() -> void:
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()

func _on_timer_timeout() -> void:
	if health_bar.value >= 0:
		health_bar.value -= init_health / time_to_die
		timer.start()

func _process(_delta: float) -> void:
	var travis_body = travis.get_node("TravisBody")
	if travis_body.velocity.length() > 0:
		camera.position_smoothing_enabled = true
		camera.position_smoothing_speed = 20.0
	else:
		camera.position_smoothing_enabled = false
	if Input.is_action_pressed("inventory"):
		timer.paused = true
		inventory.display()
