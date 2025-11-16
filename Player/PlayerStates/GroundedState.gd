extends PlayerState
class_name PlayerGroundState

const SPEED : float = 2.5
const ACCELERATION : float = 3.0
const DECELERATION : float = 4.0

var timer : Timer = Timer.new()

func _ready() -> void:
	timer.autostart = false
	timer.wait_time = 0.4
	timer.timeout.connect(_on_step_timeout)
	add_child(timer)

func exit():
	timer.stop()

func physics_update(_delta:float):
	if player.is_moving():
		if timer.is_stopped():
			timer.start()
	else:
		timer.stop()

	player.move_player(SPEED, ACCELERATION, DECELERATION)
	transition()

func transition():
	if Input.is_action_just_pressed("Run"):
		if (Stamina.stamina > 0):
			fsm.change_state("run")
	if Input.is_action_just_pressed("jump"):
		if (Stamina.stamina >= 10):
			Stamina.stamina -= 10
			fsm.change_state("jump")
			
		else:
			Stamina.stamina_bar_color.emit()
	if Input.is_action_just_pressed("slide"):
		fsm.change_state('crouch')
	if !player.is_on_floor():
		fsm.change_state('air')

func _on_step_timeout()->void:
	player.play_step_sound()
