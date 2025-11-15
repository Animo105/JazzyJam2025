extends PlayerState
class_name PlayerRunState

const SPEED : float = 10.0
const ACCELERATION : float = 6.0
const DECELERATION : float = 8.0
const BOP_AMOUNT : float = 0.08
const BOP_FRQ : float = 0.006

var tilt_tween : Tween

func physics_update(delta:float):
	player.camera.rotation.z = lerp(player.camera.rotation.z, sin(Time.get_ticks_msec()*BOP_FRQ)*BOP_AMOUNT, delta)
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	if Input.is_action_just_pressed("jump"):
		player.jump()
	transition()
	
func enter():
	player.basic_fov += 10
	Stamina.timerStaminaUse.start()
	Stamina.timerStaminaRegen.stop()

func exit():
	player.basic_fov -= 10
	var tween : Tween = create_tween()
	tween.tween_property(player.camera, "rotation", Vector3(player.camera.rotation.x,player.camera.rotation.y,0), 0.2)
	Stamina.timerStaminaUse.stop()
	Stamina.timerStaminaRegen.start()

func transition():
	if !Input.is_action_pressed("forward"):
		fsm.change_state("ground")
	if (Stamina.stamina <= 0):
		Stamina.stamina_bar_color.emit()
		fsm.change_state("ground")
	if Input.is_action_just_pressed("Run"):
		fsm.change_state("ground")
	if Input.is_action_just_pressed("slide"):
		if(Stamina.stamina >= 40):
			Stamina.stamina -= 40
			fsm.change_state('slide')
		else:
			Stamina.stamina_bar_color.emit()
	if !player.is_on_floor():
		fsm.change_state('air')
