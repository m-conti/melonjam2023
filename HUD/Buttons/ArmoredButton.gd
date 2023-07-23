extends ButtonShop
class_name ArmoredButton

@export var duration: float = 20 # in seconds
@export var armor_mod: int = 10
@export var speed_mod: float = 0.9

func __on_pressed():
	for child in map.get_children():
		if child is Enemy:
			ArmorModifier.new(child, duration, [armor_mod])
			SpeedModifier.new(child, duration, [speed_mod])
	buy()
