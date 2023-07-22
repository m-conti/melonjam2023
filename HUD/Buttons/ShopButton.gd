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
	queue_redraw()


func _input(event):
	if ghost_tower == null:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			ghost_tower.place_tower(map.tilemap.local_to_map(event.position))
			ghost_tower = null
		
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			ghost_tower.queue_free()
			ghost_tower = null
		
		queue_redraw()


func _draw():
	if ghost_tower == null:
		return
	
	draw_arc(ghost_tower.position, ghost_tower.get_node("Area2D/CollisionShape2D").shape.radius, 0., TAU, 100, Color.RED)
