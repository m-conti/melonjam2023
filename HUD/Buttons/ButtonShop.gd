extends Button
class_name ButtonShop

@export var cost: int = 100
@export_enum("gold", "corruption") var unit_cost = "gold"

var map: Map:
	get: return GameState.game.displayed_map

func __on_pressed(): pass

func _on_pressed():
	if not can_be_purchase(): return
	__on_pressed()

func buy():
	if unit_cost == "gold": return PlayerState.remove_gold(cost)
	if unit_cost == "corruption": return PlayerState.remove_corruption(cost)

func _ready():
	pressed.connect(_on_pressed)

func can_be_purchase() -> bool:
	if unit_cost == "gold": return PlayerState.has_enought_gold(cost)
	if unit_cost == "corruption": return PlayerState.has_enought_corruption(cost)
	return false
