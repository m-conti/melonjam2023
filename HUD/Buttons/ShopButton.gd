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
	
	var case_size: Vector2 = get_viewport_rect().size / Vector2(map.width, map.height)
	
	ghost_tower.global_position = (get_viewport().get_mouse_position() / case_size).floor() * case_size
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		ghost_tower.modulate = Color.WHITE
