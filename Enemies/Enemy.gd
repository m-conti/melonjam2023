extends Node2D
class_name Enemy

@export var armor: int = 0
@export var speed: int = 5 # px / s
@export var hp: int = 10

@export var fly: bool = false

@onready var map: Map = get_parent()
var path_idx: int = 0
var path: PackedVector2Array = PackedVector2Array()

signal damage(amount)


func init(path):
	self.path = path


func _ready():
#	print("New Enemy", self)
#	print("base values:")
#	print("armor:",  armor)
#	print("speed:", speed)
#	print("hp:", hp)
#	print("Modified values:")
#	print("armor:",  armor)
#	print("speed:", speed)
#	print("hp:", hp)
	pass


func _on_damage(amount):
	hp -= amount
	if hp <= 0:
		queue_free()


func _process(delta_time):
	if path.size() <= 0:
		return
	
	var target_pos: Vector2 = map.tilemap.map_to_local(path[path_idx])
	position = position.move_toward(target_pos, speed * delta_time)
	
	if target_pos.is_equal_approx(position):
		path_idx += 1
		path_idx %= path.size()
