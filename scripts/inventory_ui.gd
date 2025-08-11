extends Control

enum InventoryState {
	SHOWING,
	HIDEN
}

var items = {}

var state = InventoryState.HIDEN
var canvas
var on_click_bottle

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

func setup(_on_click_bottle: Callable) -> void:
	on_click_bottle = _on_click_bottle

func _process(_delta: float) -> void:
	if state == InventoryState.HIDEN:
		canvas.visible = false
	else:
		canvas.visible = true
	if items["bottle"]["selected"]:
		items["bottle"]["button"].button_pressed = true
	else:
		items["bottle"]["button"].button_pressed = false

func display() -> void:
	state = InventoryState.SHOWING

# func undisplay() -> void:
#	state = InventoryState.HIDEN

func _on_bottle_pressed() -> void:
	print("PRessing bottle")
	if items["bottle"]["selected"]:
		items["bottle"]["selected"] = false
	else:
		items["bottle"]["selected"] = true
	state = InventoryState.HIDEN
	on_click_bottle.call()
