extends CharacterBody2D
class_name Enemy

@export var armor: int = 0
@export var speed: int = 5
@export var hp: int = 10

@export var fly: bool = false

func _ready():
	print("New Enemy", self)
	print("base values:")
	print("armor:",  armor)
	print("speed:", speed)
	print("hp:", hp)
	print("Modified values:")
	print("armor:",  armor)
	print("speed:", speed)
	print("hp:", hp)
