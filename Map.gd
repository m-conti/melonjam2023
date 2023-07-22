extends Node2D
class_name Map


@export var width: int = 20
@export var height: int = 20
@onready var tilemap: TileMap = get_node("TileMap")

var grid: Array = []


func _init_grid():
	for x in width:
		grid.append([])
		for y in height:
			grid[x].append(null)


func _init():
	_init_grid()


func is_in_grid(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height
