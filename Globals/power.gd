extends Node

signal on_power_update(value : int)
signal flashlight_on(enable : bool)
signal recharging(enable : bool)

var power : int:
	set(value):
		power = clamp(value, 0, 100)
		on_power_update.emit(value)
var timer : Timer = Timer.new()
var timerCharge : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timer)
	add_child(timerCharge)
	timer.timeout.connect(_on_timer_timeout)
	timerCharge.timeout.connect(_on_timerCharge_timeout)
	timer.wait_time = 5
	timerCharge.wait_time = 0.5
	timer.autostart = true
	timerCharge.autostart = true
	power = 100
	flashlight_on.connect(_on_flashlight_change)
	recharging.connect(_on_recharge)

func reset():
	timer.stop()
	timerCharge.stop()
	timer.wait_time = 5
	timerCharge.wait_time = 0.5
	timer.autostart = true
	timerCharge.autostart = true
	power = 100
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_flashlight_change(is_on : bool):
	if is_on:
		timer.start()
	else:
		timer.stop()

func _on_timer_timeout():
	if power == 0:
		timer.stop()
	else:
		power -= 5

func _on_recharge(recharginOn : bool):
	if recharginOn:
		timerCharge.start()
		print("charging_start")
	elif !recharginOn:
		timerCharge.stop()
		print("charging_stopped")

func _on_timerCharge_timeout():
	power +=5
