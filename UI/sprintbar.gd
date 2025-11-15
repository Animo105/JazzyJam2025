extends ProgressBar



func _ready() -> void:
	Stamina.stamina_bar_color.connect(on_stamina_bar_color)
	Stamina.on_stamina_update.connect(on_stamina_update)
	value = Stamina.stamina
	self_modulate = Color(1,1,1, 0)

func on_stamina_update(stamina : int):
	var tween = create_tween()
	value = stamina
	if(value == 100):
		tween.tween_property(self,"self_modulate",Color(1,1,1,0),1)
	else:
		tween.tween_property(self,"self_modulate",Color(1,1,1,1),0.5)

func on_stamina_bar_color():
	for i in 4:
		modulate = Color(1,0,0,1)
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1,1,1,1)
		await get_tree().create_timer(0.1).timeout
	
