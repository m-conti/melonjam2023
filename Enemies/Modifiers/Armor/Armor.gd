extends Modifier
class_name ArmorModifier

var armor_mod: int

func _init(enemy: Enemy, duration: float = -1., args: Array = []):
	armor_mod = args[0]
	super._init(enemy, duration, args)


func apply_modifier(target: Enemy):
	target.armor += armor_mod


func unapply_modifier(target: Enemy):
	target.armor -= armor_mod
