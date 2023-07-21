extends Tower


@export var damage: int = 1


func on_enemy_hit(enemy: Enemy):
	enemy.damage_received.emit(damage) # TODO: THIS
