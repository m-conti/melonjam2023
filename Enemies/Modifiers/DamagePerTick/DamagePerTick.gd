extends Modifier
class_name DamagePerTick

var damage_per_tick: int = 1
var tick_duration: float = 0.2

var tick_timer: Timer


func _init(enemy: Enemy, duration: float = -1., args: Array = []):
	damage_per_tick = args[0]
	tick_duration = args[1]
	
	super._init(enemy, duration, args)


func apply_modifier(target: Enemy):
	tick_timer = Timer.new()
	tick_timer.wait_time = tick_duration
	tick_timer.autostart = true
	tick_timer.timeout.connect(func(): enemy.damage.emit(damage_per_tick))
	
	add_child(tick_timer)
