extends Label


func _ready() -> void:
	hide()
	Global.lookingAtPlush.connect(_on_looking_at_plush)
