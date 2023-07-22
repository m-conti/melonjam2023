extends Tower


@export var damage_radius: float = 2.
@export var damage: int = 5


func on_enemy_hit(enemy: Enemy):
	var area: Area2D = Area2D.new()
	var shape: CollisionShape2D = CollisionShape2D.new()
	shape.shape = CircleShape2D.new()
	shape.shape.radius = damage_radius
	area.add_child(shape)
	
	area.area_entered.connect(damage_enemy)
	
	enemy.add_child(area)
	area.queue_free()


func is_attackable(enemy: Enemy) -> bool:
	return enemy.fly


func damage_enemy(enemy):
	if not (enemy is Enemy and is_attackable(enemy)):
		return
	
	enemy.damage.emit(damage)
