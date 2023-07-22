extends Node
class_name Modifier

var enemy: Enemy = null

func apply_modifier(target: Enemy):
	pass


func unapply_modifier(target: Enemy):
	pass


func init_timer(duration: float):
	var timer: Timer = Timer.new()
		
	timer.wait_time = duration
	timer.autostart = true
	timer.one_shot = true
	timer.timeout.connect(queue_free)
	
	add_child(timer)

func _init(enemy: Enemy, duration: float = -1., args: Array = []):
	self.enemy = enemy
	if duration > 0.:
		init_timer(duration)
	
	self.enemy.add_child(self)


func _enter_tree():
	apply_modifier(enemy)


func _exit_tree():
	unapply_modifier(enemy)
