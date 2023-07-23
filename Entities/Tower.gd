extends Node2D
class_name Tower

var enemies_inside: Array = []
@export var attack_cooldown: float = 1.0
@onready var timer: Timer = $Timer
@export var attacking_type: EAttackingType
@onready var map: Map = get_parent().map

@export var damage_animation: PackedScene


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

func _enter_tree():
	set_multiplayer_authority(get_parent().get_multiplayer_authority())


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


func _on_animation_finished(enemies: Array):
	$AudioStreamPlayer.stop()
	for enemy in enemies:
		if is_instance_valid(enemy):
			var anim: Sprite2D = damage_animation.instantiate()
			enemy.add_child(anim)
			anim.get_node("AnimationPlayer").animation_finished.connect(func(x): anim.queue_free())
			on_enemy_hit(enemy)


func _on_timer_timeout():
	var enemies_attackable = enemies_inside.filter(func(enemy): return enemy.hp > 0 and is_attackable(enemy))
	
	if enemies_attackable.size() <= 0:
		return
	
	if attacking_type == EAttackingType.lowest_health:
		enemies_attackable.sort_custom(func(x, y): return x.hp <= y.hp)
		anime_and_attack_enemies([enemies_attackable[0]])
	elif attacking_type == EAttackingType.biggest_health:
		enemies_attackable.sort_custom(func(x, y): return x.hp >= y.hp)
		anime_and_attack_enemies([enemies_attackable[0]])
	elif attacking_type == EAttackingType.random:
		anime_and_attack_enemies([enemies_attackable.pick_random()])
	elif attacking_type == EAttackingType.first_in_line:
		anime_and_attack_enemies([enemies_attackable[0]])
	elif attacking_type == EAttackingType.last_in_line:
		anime_and_attack_enemies([enemies_attackable[enemies_attackable.size() - 1]])
	elif attacking_type == EAttackingType.all:
		anime_and_attack_enemies(enemies_attackable)


func is_attackable(enemy: Enemy) -> bool:
	return false


func anime_and_attack_enemies(enemies: Array):
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("Attack", -1, 1.5 / attack_cooldown)
	$AnimationPlayer.animation_finished.connect(func(x): _on_animation_finished(enemies), CONNECT_ONE_SHOT)


func on_enemy_hit(enemy):
	pass


func can_be_placed(pos: Vector2i) -> bool:
	if not map.is_in_grid(pos):
		return false
	if map.grid[pos.x][pos.y] == null:
		return true
	return false


func place_on_map(pos: Vector2i):
	has_been_placed.emit(pos)
	timer.start(attack_cooldown)

func get_info() -> String:
	return str(attacking_type)
