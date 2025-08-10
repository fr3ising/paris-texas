extends Control

enum InventoryState {
	SHOWING,
	HIDEN
}

var items = {}

var state = InventoryState.HIDEN
var canvas

func _ready() -> void:
	items = {
		"bottle": { "button": $CanvasLayer.get_node("GridContainer").get_node("Bottle"),
					"selected": false },
		"postit": { "button": $CanvasLayer.get_node("GridContainer").get_node("PostIt"),
					"selected": false }
	}
	canvas = $CanvasLayer
	print(items["bottle"]["button"])
	items["bottle"]["button"].pressed.connect(_on_bottle_pressed)
	var postit = $CanvasLayer.get_node("GridContainer").get_node("PostIt")
	print(items["postit"]["button"])

func _process(_delta: float) -> void:
	if state == InventoryState.HIDEN:
		print("HIDING")
		canvas.visible = false
	else:
		canvas.visible = true
	if items["bottle"]["selected"]:
		items["bottle"]["button"].button_pressed = true
	else:
		items["bottle"]["button"].button_pressed = false

func showing() -> void:
	state = InventoryState.SHOWING

func hiding() -> void:
	state = InventoryState.HIDEN

func _on_bottle_pressed() -> void:
	print("PRessing bottle")
	if items["bottle"]["selected"]:
		items["bottle"]["selected"] = false
	else:
		items["bottle"]["selected"] = true
	print("Hiding canvas layer")
	state = InventoryState.HIDEN
