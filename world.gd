extends Node3D
var inShape : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#ToastManager.add_toast(ToastManager.ToastData.new("New message", "DAMN IT WORKS!!!", 5))
	pass


func _on_tutoriel_message_body_entered(body: Node3D) -> void:
	if body is Player:
		Global.message.emit("Maintenir SHIFT pour courrir")


func _on_tutoriel_message_body_exited(body: Node3D) -> void:
	if body is Player:
		Global.message.emit("")
