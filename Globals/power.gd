extends Node

signal on_power_update(int)
signal flashlight_on(bool)
signal recharging(bool)

var power : int:
	set(value):
		power = value
		on_power_update.emit(value)
var timer : Timer = Timer.new()
var timerCharge : Timer = Timer.new()
var charging : bool = false

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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_flashlight_change(is_on : bool):
	if is_on:
		timer.start()
	else:
		timer.stop()

func _on_timer_timeout():
	if power >= 0:
		power -= 5

func _on_recharge(recharginOn : bool):
	if recharginOn:
		timerCharge.start()
	elif !recharginOn:
		timerCharge.stop()
		charging = false
		Stamina.timerStaminaRegen.start()

func _on_timerCharge_timeout():
	charging = true
	if Stamina.stamina > 0:
		Stamina.timerStaminaRegen.stop()
		if power < 100:
			power +=2
			Stamina.stamina -= 10
