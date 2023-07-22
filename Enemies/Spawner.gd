extends Node2D
class_name Spawner

@export var cooldown: float = 2. # in second
@export var enemy: PackedScene
@onready var map: Map = find_parent("Map")


func spawn():
	var new_enemy: Enemy = enemy.instantiate()
	new_enemy.init(PackedVector2Array([Vector2(1, 1), Vector2(1, 5), Vector2(5, 5), Vector2(5, 1)]))
	
	map.add_child(new_enemy)
	new_enemy.position = position


func _ready():
	var timer: Timer = get_node("Timer")
	timer.wait_time = cooldown
	timer.timeout.connect(spawn)
