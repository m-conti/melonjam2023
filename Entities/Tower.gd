extends Node2D
class_name Tower

var enemies_inside: Array = []
@export var attack_cooldown: float = 1.0
@onready var timer: Timer = $Timer
@export var attacking_type: EAttackingType
@onready var map: Map = get_parent().map
@export var price: int = 100


signal has_been_placed(pos: Vector2i)


enum EAttackingType
{
	lowest_health,
	biggest_health,
	random,
	first_in_line,
	last_in_line,
	all
}


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
	var enemies_attackable = enemies_inside.filter(is_attackable)
	
	if enemies_attackable.size() <= 0:
		return
	
	if attacking_type == EAttackingType.lowest_health:
		enemies_attackable.sort_custom(func(x, y): return x.hp <= y.hp)
		on_enemy_hit(enemies_attackable[0])
	elif attacking_type == EAttackingType.biggest_health:
		enemies_attackable.sort_custom(func(x, y): return x.hp >= y.hp)
		on_enemy_hit(enemies_attackable[0])
	elif attacking_type == EAttackingType.random:
		on_enemy_hit(enemies_attackable.pick_random())
	elif attacking_type == EAttackingType.first_in_line:
		on_enemy_hit(enemies_attackable[0])
	elif attacking_type == EAttackingType.last_in_line:
		on_enemy_hit(enemies_attackable[enemies_attackable.size() - 1])
	elif attacking_type == EAttackingType.all:
		for enemy in enemies_attackable:
			on_enemy_hit(enemy)


func is_attackable(enemy: Enemy) -> bool:
	return false


func on_enemy_hit(enemy):
	pass


func can_be_placed(pos: Vector2i) -> bool:
	if not map.is_in_grid(pos):
		return false
	if map.grid[pos.x][pos.y] == null:
		return true
	return false


func place_tower(pos: Vector2i):
	if not can_be_placed(pos):
		return
	
	map.grid[pos.x][pos.y] = self
	has_been_placed.emit(pos)
	timer.start(attack_cooldown)
