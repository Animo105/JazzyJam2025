extends Panel
class_name Toast

var message : String
var header : String

@onready var header_label: Label = $Header
@onready var message_label: Label = $Header/Message

func _ready() -> void:
	header_label.text = header
	message_label.text = message
	add_child(header_label)
	add_child(message_label)
