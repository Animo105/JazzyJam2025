extends PlayerState
class_name PlayerGroundState

const SPEED : float = 5.0
const ACCELERATION : float = 3.0
const DECELERATION : float = 4.0
@onready var stepup: CollisionShape3D = $"../../stepup"
@onready var stepup_2: CollisionShape3D = $"../../stepup2"
@onready var stepup_3: CollisionShape3D = $"../../stepup3"

func enter():
	stepup.disabled = false
	stepup_2.disabled = false
	stepup_3.disabled = false

func exit():
	stepup.disabled = true
	stepup_2.disabled = true
	stepup_3.disabled = true

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
			fsm.change_state("jump")
			
		else:
			Stamina.stamina_bar_color.emit()
	if Input.is_action_just_pressed("slide"):
		fsm.change_state('crouch')
	if !player.is_on_floor():
		fsm.change_state('air')
