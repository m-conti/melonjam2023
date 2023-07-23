extends PlaceOnMap
class_name TowerButton


func can_be_placed(pos: Vector2i) -> bool:
	return ghost.can_be_placed(pos)


func _draw():
	if ghost == null or not can_be_placed(map.tilemap.local_to_map(get_viewport().get_mouse_position() / map.tilemap.scale)):
		return
	
	draw_arc(ghost.position, ghost.get_node("Area2D/CollisionShape2D").shape.radius, 0., TAU, 100, Color.BLACK, 2)
