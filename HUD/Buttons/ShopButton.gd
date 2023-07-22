class_name ShopButton
extends Button


@export var tower_instance: PackedScene
var ghost_tower: Tower = null
@onready var map: Map = find_parent("Map")


func _on_pressed():
	var new_tower: Tower = tower_instance.instantiate()
	
	new_tower.modulate = Color(Color.WHITE, 0.5)
	
	ghost_tower = new_tower
	add_child(new_tower)


func _process(delta_time):
	if ghost_tower == null:
		return
	
	var mouse_pos: Vector2i = map.tilemap.local_to_map(get_viewport().get_mouse_position())
	
	if not ghost_tower.can_be_placed(mouse_pos):
		ghost_tower.visible = false
		return
	
	ghost_tower.visible = true
	ghost_tower.global_position = map.tilemap.map_to_local(mouse_pos)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		ghost_tower.modulate = Color.WHITE
		ghost_tower.place_tower(mouse_pos)
		ghost_tower = null
