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
	if enemy is not Enemy:
		return
	var enemy = area.get_parent()
	
	enemies_inside.append(enemy)


func _on_area_2d_area_exited(area):
	var enemy = area.get_parent()
	if enemy is not Enemy:
		return
	
	enemies_inside.erase(enemy)


func _on_timer_timeout():
	if attacking_type == EAttackingType.lowest_health:
		pass
	elif attacking_type == EAttackingType.biggest_health:
		pass
	elif attacking_type == EAttackingType.random:
		on_enemy_hit(enemies_inside.pick_random())
	elif attacking_type == EAttackingType.first_in_line:
		pass
	elif attacking_type == EAttackingType.last_in_line:
		pass
	elif attacking_type == EAttackingType.all:
		for enemy in enemies_inside:
			on_enemy_hit(enemy)


func on_enemy_hit(enemy):
	pass
