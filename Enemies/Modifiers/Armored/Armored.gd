extends Modifier

var armor_mod = 5
var speed_mod = -1

func apply_modifier(target):
	target.armor += armor_mod
	target.speed += speed_mod
