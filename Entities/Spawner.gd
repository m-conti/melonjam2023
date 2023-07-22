extends Node2D
class_name Spawner

@export var cooldown: float = 2. # in second
@export var enemy: PackedScene


func spawn():
	var new_enemy: Enemy = enemy.instantiate()
	new_enemy.init(PackedVector2Array([Vector2(1, 1), Vector2(1, 5), Vector2(5, 5), Vector2(5, 1)]))
	
	get_parent().add_child(new_enemy)
	new_enemy.position = position


func place_on_map(pos: Vector2i):
	var timer: Timer = get_node("Timer")
	timer.wait_time = cooldown
	timer.timeout.connect(spawn)
