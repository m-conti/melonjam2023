extends Button
class_name MyMenuBar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggled(button_pressed):
	get_node("BoxContainer").visible = button_pressed


func _on_button_pressed():
	pass # Replace with function body.
