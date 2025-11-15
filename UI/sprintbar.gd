extends ProgressBar

func _ready() -> void:
	Stamina.on_stamina_update.connect(on_stamina_update)
	value = Stamina.stamina

func on_stamina_update(stamina : int):
	value = stamina
	show()
	if(value == 100):
		hide()
