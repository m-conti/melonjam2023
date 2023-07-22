extends Button
class_name ButtonShop

@onready var map: Map = get_node("../../../../../..")


func _on_pressed():
	pass


func _ready():
	pressed.connect(_on_pressed)
