extends PlayerState
class_name PlayercrouchState

const SPEED : float = 3.0
const ACCELERATION : float = 4.0
const DECELERATION : float = 4.0

func enter():
	player.set_crouch(true)

func exit():
	player.set_crouch(false)

func physics_update(_delta:float):
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	
	transition()

func transition():
	if !Input.is_action_pressed("slide"):
		fsm.change_state('ground')
