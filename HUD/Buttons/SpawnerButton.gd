extends PlaceOnMap
class_name SpawnerButton

func _ready():
	super._ready()
	self.activable_remote = true

func can_be_placed(pos: Vector2i) -> bool:
	return map.is_in_grid(pos) and map.grid[pos.x][pos.y] == null
