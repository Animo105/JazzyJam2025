extends PlayerState
class_name PlayerRunState

const SPEED : float = 10.0
const ACCELERATION : float = 6.0
const DECELERATION : float = 8.0

func physics_update(_delta:float):
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	if Input.is_action_just_pressed("jump"):
		player.jump()
	transition()

func enter():
	Stamina.timerStaminaUse.start()
	Stamina.timerStaminaRegen.stop()

func exit():
	Stamina.timerStaminaUse.stop()
	Stamina.timerStaminaRegen.start()

func transition():
	if Input.is_action_just_released("forward"):
		fsm.change_state("ground")
	if (Stamina.stamina <= 0):
		fsm.change_state("ground")
	if Input.is_action_just_pressed("Run"):
		fsm.change_state("ground")
	if Input.is_action_just_pressed("slide"):
		fsm.change_state('slide')
	if !player.is_on_floor():
		fsm.change_state('air')
