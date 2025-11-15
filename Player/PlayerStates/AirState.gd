extends PlayerState
class_name PlayerAirState

func physics_update(delta:float):
	player.apply_gravity(delta)
	
	if player.is_on_floor():
		
		fsm.change_state('ground')
