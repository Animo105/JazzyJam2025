extends SpotLight3D

var is_flashlight_on : bool = false

func _ready() -> void:
	hide()

func _physics_process(delta: float) -> void:
	if (Power.power <= 0):
		is_flashlight_on = false
		hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight"):
		if Power.power > 0:
			if is_flashlight_on == false:
				show()
				is_flashlight_on = true
			else:
				hide()
				is_flashlight_on = false
			Power.flashlight_on.emit(is_flashlight_on)
