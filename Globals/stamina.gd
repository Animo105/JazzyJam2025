extends Node

signal on_stamina_update(int)
signal stamina_bar_color()

var stamina : int:
	set(value):
		stamina = value
		on_stamina_update.emit(value)
var timerStaminaUse : Timer = Timer.new()
var timerStaminaRegen : Timer = Timer.new()
enum _State {Regen, Running}
var state : _State = _State.Regen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timerStaminaUse)
	timerStaminaUse.timeout.connect(_on_timerStaminaUse_timeout)
	timerStaminaUse.wait_time = 0.1
	timerStaminaUse.autostart = true
	add_child(timerStaminaRegen)
	timerStaminaRegen.timeout.connect(_on_timerStaminaRegen_timeout)
	timerStaminaRegen.wait_time = 0.08
	timerStaminaRegen.autostart = true
	timerStaminaRegen.start()
	stamina = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timerStaminaUse_timeout():
	stamina -= 1

func _on_timerStaminaRegen_timeout():
	if(state == _State.Regen):
		if (stamina < 100):
			stamina += 1
