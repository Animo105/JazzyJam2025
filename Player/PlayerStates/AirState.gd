extends PlayerState
class_name PlayerAirState

const SPEED : float = 5
const ACCELERATION : float = 0.2
const DECELERATION : float = 0.4

func physics_update(delta:float):
	player.apply_gravity(delta)
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	if player.is_on_floor():
		
		fsm.change_state('ground')
