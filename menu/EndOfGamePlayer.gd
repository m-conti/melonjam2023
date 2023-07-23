extends Control
class_name EndOfGamePlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_data(data: Dictionary):
	$Name.text = data.name
	$Corruption.text = str(data.corruption)
	$Gold.text = str(data.gold)
	if data.dead:
		$Status.text = "DEAD"
	else:
		$Status.text = "WINNER"
	pass
