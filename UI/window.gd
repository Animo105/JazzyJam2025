extends Label

func _ready() -> void:
	hide()
	Global.lookingAtPlush.connect(_on_looking_at_plush)

func _on_looking_at_plush(looking : bool):
	if looking:
		text = "press E to collect"
		show()
	else:
		hide()
