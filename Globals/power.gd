extends Node

signal on_power_update(int)
signal flashlight_on(bool)

var power : int:
	set(value):
		power = value
		on_power_update.emit(value)
var timer : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = 5
	timer.autostart = true
	power = 100
	flashlight_on.connect(_on_flashlight_change)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_flashlight_change(is_on : bool):
	if is_on == true:
		timer.start()
	else:
		timer.stop()

func _on_timer_timeout():
	if power >= 0:
		power -= 5
	else:
		pass
