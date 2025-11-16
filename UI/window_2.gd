extends Label

func _ready() -> void:
	text = ""
	Global.message.connect(_on_message_showcase)

func _on_message_showcase(message : String):
	text = message
