extends Label

func _ready() -> void:
	hide()
	text = "press E to collect"
	Global.lookingAtPlush.connect(_on_looking_at_plush)

func _on_looking_at_plush(looking : bool):
	if looking:
		show()
	else:
		hide()
