extends Sprite2D


func _ready() -> void:
	Power.on_power_update.connect(on_power_update)
	frame = 4

func on_power_update(power : int):
	if(power <= 0):
		frame = 0
	elif(power <= 25):
		frame = 1
	elif(power <= 50):
		frame = 2
	elif(power <= 75):
		frame = 3
	elif(power >= 76):
		frame = 4
