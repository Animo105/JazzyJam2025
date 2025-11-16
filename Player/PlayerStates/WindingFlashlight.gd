extends PlayerState
class_name windingFlashlight

func physics_update(_delta:float):
	Power.recharging.emit(true)
	transition()

func enter():
	pass

func exit():
	pass

func transition():
	if (Stamina.stamina <= 0):
		Stamina.stamina_bar_color.emit()
		fsm.change_state("ground")
	if Input.is_action_just_released("Run"):
		fsm.change_state("ground")
	if Input.is_action_just_pressed("slide"):
		if(Stamina.stamina >= 40):
			Stamina.stamina -= 40
			fsm.change_state('slide')
		else:
			Stamina.stamina_bar_color.emit()
	if !player.is_on_floor():
		fsm.change_state('air')
