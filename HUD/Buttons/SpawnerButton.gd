extends PlaceOnMap
class_name SpawnerButton


func can_be_placed(pos: Vector2i) -> bool:
	return map.is_in_grid(pos) and map.grid[pos.x][pos.y] == null


func place_on_map(pos: Vector2i):
	ghost.modulate = Color.WHITE
	map.add_at_pos(ghost, pos)
