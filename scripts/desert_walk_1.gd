extends Node2D

var TravisScene := preload("res://scenes/travis.tscn")
var DesertScene := preload("res://scenes/desert.tscn")
var DesertSkyScene := preload("res://scenes/desert_sky.tscn")

var travis
var camera

func _ready() -> void:
	var desert = DesertScene.instantiate()
	add_child(desert)
	var desert_sky = DesertSkyScene.instantiate()
	add_child(desert_sky)
	var travis_spawn_point = desert.get_node("TravisSpawnPoint")
	travis = TravisScene.instantiate()
	travis.global_position = travis_spawn_point.global_position
	add_child(travis)
	var travis_body = travis.get_node("TravisBody")
	camera = Camera2D.new()
	camera.position_smoothing_enabled = false
	camera.make_current()
	travis_body.add_child(camera)

func _process(_delta: float) -> void:
	var travis_body = travis.get_node("TravisBody")
	if travis_body.velocity.length() > 0:
		camera.position_smoothing_enabled = true
		camera.position_smoothing_speed = 20.0
	else:
		camera.position_smoothing_enabled = false
