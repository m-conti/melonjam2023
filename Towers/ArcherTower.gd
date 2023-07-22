extends Tower


@export var damage: int = 7


func on_enemy_hit(enemy: Enemy):
	enemy.damage.emit(damage)


func is_attackable(enemy: Enemy) -> bool:
	return true
