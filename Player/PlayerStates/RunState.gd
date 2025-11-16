extends PlayerState
class_name PlayerRunState

const SPEED : float = 3.7
const ACCELERATION : float = 6.0
const DECELERATION : float = 8.0
var tilt_tween : Tween
var timer : Timer = Timer.new()

func _ready() -> void:
	timer.autostart = false
	timer.wait_time = 0.2
	timer.timeout.connect(_on_step_timeout)
	add_child(timer)

func physics_update(_delta:float):
	if player.is_moving():
		if timer.is_stopped():
			timer.start()
	else:
		timer.stop()
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	if Input.is_action_just_pressed("jump"):
		player.jump()
	transition()
	
func enter():
	player.basic_fov += 10
	Stamina.timerStaminaUse.start()
	Stamina.timerStaminaRegen.stop()

func exit():
	timer.stop()
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

func _on_step_timeout():
	player.play_step_sound()
