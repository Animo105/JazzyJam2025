extends PlayerState
class_name PlayerGroundState

const SPEED : float = 5.0
const ACCELERATION : float = 3.0
const DECELERATION : float = 4.0

func physics_update(_delta:float):
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	transition()

func transition():
	if Input.is_action_just_pressed("Run"):
		if (Stamina.stamina > 0):
			fsm.change_state("run")
	if Input.is_action_just_pressed("jump"):
		if (Stamina.stamina >= 10):
			Stamina.stamina -= 10
			player.jump()
	if Input.is_action_just_pressed("slide"):
		fsm.change_state('crouch')
	if !player.is_on_floor():
		fsm.change_state('air')
