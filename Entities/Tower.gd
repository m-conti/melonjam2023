extends Node2D
class_name Tower

var enemies_inside: Array = []
@export var cooldown: float = 1.0
@onready var timer: Timer = $Timer
@export var attacking_type: EAttackingType


enum EAttackingType
{
	lowest_health,
	biggest_health,
	random,
	first_in_line,
	last_in_line,
	all
}


func _ready():
	timer.wait_time = cooldown


func _on_area_2d_area_entered(area):
	var enemy = area.get_parent()
	if not enemy is Enemy:
		return
	
	enemies_inside.append(enemy)


func _on_area_2d_area_exited(area):
	var enemy = area.get_parent()
	if not enemy is Enemy:
		return
	
	enemies_inside.erase(enemy)


func _on_timer_timeout():
	if enemies_inside.size() <= 0:
		return
	
	if attacking_type == EAttackingType.lowest_health:
		enemies_inside_copy = enemies_inside.duplicate()
		enemies_inside_copy.sort_custom(func(x, y): return x.health <= y.health)
		on_enemy_hit(enemies_inside_copy[0])
	elif attacking_type == EAttackingType.biggest_health:
		enemies_inside_copy = enemies_inside.duplicate()
		enemies_inside_copy.sort_custom(func(x, y): return x.health >= y.health)
		on_enemy_hit(enemies_inside_copy[0])
	elif attacking_type == EAttackingType.random:
		on_enemy_hit(enemies_inside.pick_random())
	elif attacking_type == EAttackingType.first_in_line:
		on_enemy_hit(enemies_inside[0])
	elif attacking_type == EAttackingType.last_in_line:
		on_enemy_hit(enemies_inside[enemies_inside.size() - 1])
	elif attacking_type == EAttackingType.all:
		for enemy in enemies_inside:
			on_enemy_hit(enemy)


func on_enemy_hit(enemy):
	pass
