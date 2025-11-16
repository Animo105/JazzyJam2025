extends PlayerState
class_name windingFlashlight

func physics_update(_delta:float):
	transition()

func enter():
	Power.recharging.emit(true)
	pass

func exit():
	Power.recharging.emit(false)
	pass

func transition():
	if !Input.is_action_pressed("recharging"):
		fsm.change_state("ground")
