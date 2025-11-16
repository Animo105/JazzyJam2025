extends PlayerState
class_name PlayercrouchState

const SPEED : float = 2.0
const ACCELERATION : float = 4.0
const DECELERATION : float = 4.0

var in_ball_pit : bool = false:
	set(value):
		in_ball_pit = value
		player.is_hiding = value
		player.camera_effects.ball_effect = value

func check_in_ball_pit():
	var objects = player.detection.get_overlapping_bodies()
	if objects != []:
		for object in objects:
			if object is GameObject:
				if object.object == GameObject.BALL_PIT:
					in_ball_pit = true
					return
	in_ball_pit = false

func enter():
	check_in_ball_pit()
	player.set_crouch(true)

func exit():
	in_ball_pit = false
	player.set_crouch(false)

func physics_update(delta:float):
	player.apply_gravity(delta)
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	
	transition()

func transition():
	if !Input.is_action_pressed("slide"):
		if !player.head_ray.is_colliding():
			fsm.change_state('ground')
