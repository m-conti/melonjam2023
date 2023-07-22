extends Tower


@export var damage_radius: float = 2.
@export var damage: int = 5


func on_enemy_hit(enemy: Enemy):
	var area: Area2D = Area2D.new()
	var shape: CollisionShape2D = CollisionShape2D.new()
	shape.shape = CircleShape2D.new()
	shape.shape.radius = damage_radius
	area.add_child(shape)
	
	enemy.add_child(area)

	var timer: Timer = Timer.new()
	timer.wait_time = 0.1
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(func(): damage_all_enemies_inside(area))
	area.add_child(timer)


func is_attackable(enemy: Enemy) -> bool:
	return not enemy.fly


func damage_all_enemies_inside(area: Area2D):
	for area_inside in area.get_overlapping_areas():
		damage_enemy(area_inside.get_parent())
	
	area.queue_free()


func damage_enemy(enemy):
	if not (enemy is Enemy and is_attackable(enemy)):
		return
	
	enemy.damage.emit(damage)
