extends Modifier
class_name SpeedModifier

var speed_mod: float = 0.5


func _init(enemy: Enemy, duration: float = -1., args: Array = []):
	speed_mod = args[0]
	super._init(enemy, duration, args)


func apply_modifier(target: Enemy):
	target.speed *= speed_mod


func unapply_modifier(target: Enemy):
	target.speed /= speed_mod
