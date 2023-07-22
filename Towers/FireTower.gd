extends Tower


@export var duration: float = 2.
@export var tick_duration: float = 0.2
@export var damage_per_tick: int = 1

func on_enemy_hit(enemy: Enemy):
	DamagePerTick.new(enemy, duration, [damage_per_tick, tick_duration])


func is_attackable(enemy: Enemy) -> bool:
	return true
