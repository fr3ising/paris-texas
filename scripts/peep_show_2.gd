extends Node2D
var TravisScene := preload("res://scenes/travis.tscn")
var WaltScene := preload("res://scenes/walt.tscn")
var RoomScene := preload("res://scenes/room.tscn")

var walt
var travis

func _ready() -> void:
	var room = RoomScene.instantiate()
	add_child(room)
	var travis_spawn_point = room.get_node("TravisSpawnPoint")
	var walt_spawn_point = room.get_node("WaltSpawnPoint")
	var camera = Camera2D.new()
	travis = TravisScene.instantiate()
	add_child(travis)
	walt = WaltScene.instantiate()
	add_child(walt)
	walt.position.x += 30
	var speech = walt.get_node("WaltSpeech")
	speech.visible = false
	walt.global_position = walt_spawn_point.global_position
	travis.add_child(camera)
	var travis_body = travis.get_node("TravisBody")
	travis_body.set_collision_mask_value(1, true)
	travis.global_position = travis_spawn_point.global_position
	var walt_interaction_area = walt.get_node("InteractionArea")
	print(walt_interaction_area)
	var interaction_area = walt.get_node("InteractionArea")
	interaction_area.body_entered.connect(_hit_walt)
	interaction_area.body_exited.connect(_out_walt)

func _hit_walt(body) -> void:
	print("Hit Walt")
	print(body.name)
	print(walt)
	if body.name == "TravisBody":
		var speech = walt.get_node("WaltSpeech")
		speech.visible = true

func _out_walt(body) -> void:
	print("Out Walt")
	print(body.name)
	print(walt)
	if body.name == "TravisBody":
		var speech = walt.get_node("WaltSpeech")
		speech.visible = false


func _process(_delta: float) -> void:
	pass
