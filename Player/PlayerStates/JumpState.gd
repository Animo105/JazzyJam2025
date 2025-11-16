extends PlayerState
class_name PlayerJumpState

@onready var stepup: CollisionShape3D = $"../../stepup"
@onready var stepup_2: CollisionShape3D = $"../../stepup2"
@onready var stepup_3: CollisionShape3D = $"../../stepup3"

func enter():
	player.jump_sfx.play()
	stepup.disabled = true
	stepup_2.disabled = true
	stepup_3.disabled = true
	player.jump()

func exit():
	stepup.disabled = false
	stepup_2.disabled = false
	stepup_3.disabled = false

func physics_update(_delta:float):
	if player.velocity.y > 0:
		fsm.change_state("air")
