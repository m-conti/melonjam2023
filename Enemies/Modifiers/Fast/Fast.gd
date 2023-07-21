extends Modifier

var armor_mod = 0
var speed_mod = 5

func apply_modifier(target):
	target.speed += speed_mod
