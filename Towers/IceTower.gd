extends Tower


@export var speed_factor: float = 0.5
@export var duration: float = 1.0


func on_enemy_hit(enemy: Enemy):
	SpeedModifier.new(enemy, duration, [speed_factor])


func is_attackable(enemy: Enemy) -> bool:
	return true
