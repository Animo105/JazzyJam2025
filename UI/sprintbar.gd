extends ProgressBar



func _ready() -> void:
	Stamina.stamina_bar_color.connect(on_stamina_bar_color)
	Stamina.on_stamina_update.connect(on_stamina_update)
	value = Stamina.stamina
	self_modulate = Color(1,1,1)

func on_stamina_update(stamina : int):
	value = stamina
	show()
	if(value == 100):
		hide()

func on_stamina_bar_color():
	for i in 4:
		self_modulate = Color(1,0,0)
		await get_tree().create_timer(0.1).timeout
		self_modulate = Color(1,1,1)
		await get_tree().create_timer(0.1).timeout
	
