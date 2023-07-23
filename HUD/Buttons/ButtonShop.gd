extends Button
class_name ButtonShop

@export var cost: int = 100
@export_enum("gold", "corruption") var unit_cost = "gold"
var shop_info: PackedScene = load("res://HUD/Buttons/ShopInfo.tscn")
var infos: PanelContainer

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
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func can_be_purchase() -> bool:
	if unit_cost == "gold": return PlayerState.has_enought_gold(cost)
	if unit_cost == "corruption": return PlayerState.has_enought_corruption(cost)
	return false

func get_info() -> String:
	return "cost %d %s\n%s" % [cost, unit_cost, editor_description] 

func _on_mouse_entered():
	infos = shop_info.instantiate()
	infos.get_node("MarginContainer/Label").text = get_info()
	
	add_child(infos)

func _on_mouse_exited():
	infos.queue_free()
