extends CharacterBody2D
class_name Enemy

var armor = 0
var speed = 5
var hp = 10

func _ready():
	print("New Enemy", self)
	print("base values:")
	print("armor:",  armor)
	print("speed:", speed)
	print("hp:", hp)
	for mod in $Modifiers.get_children():
		print("applying Modifier:", mod)
		mod.apply_modifier(self)
	print("Modified values:")
	print("armor:",  armor)
	print("speed:", speed)
	print("hp:", hp)
