extends SpotLight3D

var is_flashlight_on : bool = false
@onready var clic: AudioStreamPlayer = $clic

func _ready() -> void:
	hide()

func _physics_process(_delta: float) -> void:
	if (Power.power <= 0):
		Global.message.emit("Hold F to recharge flashlight")
		var rng = RandomNumberGenerator.new()
		if !is_flashlight_on == false:
			for i in 4:
				hide()
				await get_tree().create_timer(rng.randf_range(0.05, 0.1)).timeout
				show()
				await get_tree().create_timer(rng.randf_range(0.05, 0.1)).timeout
		hide()
		is_flashlight_on = false
		Power.flashlight_on.emit(is_flashlight_on)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight"):
		if Power.power > 0:
			clic.play(0.5)
			if is_flashlight_on == false:
				show()
				is_flashlight_on = true
			else:
				hide()
				is_flashlight_on = false
			Power.flashlight_on.emit(is_flashlight_on)
