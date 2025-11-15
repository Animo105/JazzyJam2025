extends PlayerState
class_name PlayerJumpState

func enter():
	player.jump()

func physics_update(_delta:float):
	if player.velocity.y > 0:
		fsm.change_state("air")
