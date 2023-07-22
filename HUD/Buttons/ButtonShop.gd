extends Button
class_name ButtonShop

var map: Map:
	get: return GameState.game.displayed_map


func _on_pressed():
	pass


func _ready():
	pressed.connect(_on_pressed)
