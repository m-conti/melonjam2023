extends PlaceOnMap
class_name TowerButton


func can_be_placed(pos: Vector2i) -> bool:
	return ghost.can_be_placed(pos)


func _draw():
	if ghost == null:
		return
	
	draw_arc(ghost.position, ghost.get_node("Area2D/CollisionShape2D").shape.radius, 0., TAU, 100, Color.BLACK, 2)
