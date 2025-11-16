extends PlayerState
class_name PlayerAirState

const SPEED : float = 2.5
const ACCELERATION : float = 0.2
const DECELERATION : float = 0.4
@onready var stepup: CollisionShape3D = $"../../stepup"
@onready var stepup_2: CollisionShape3D = $"../../stepup2"
@onready var stepup_3: CollisionShape3D = $"../../stepup3"

func enter():
	stepup.disabled = true
	stepup_2.disabled = true
	stepup_3.disabled = true

func exit():
	player.land_sfx.play()
	stepup.disabled = false
	stepup_2.disabled = false
	stepup_3.disabled = false

func physics_update(delta:float):
	player.apply_gravity(delta)
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	if player.is_on_floor():
		
		fsm.change_state('ground')
