extends Node

var pickup : bool = false

func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interract"):
		pickup = true
		print(pickup)
