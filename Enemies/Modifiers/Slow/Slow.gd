extends Modifier

var speed_mod = 2

func apply_modifier(target):
	target.speed /= speed_mod
