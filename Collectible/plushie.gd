extends StaticBody3D
class_name plush

@export var id : int

func _physics_process(_delta: float) -> void:
	pass

func _ready() -> void:
	Global.plushCollected.connect(_on_collect)

func _on_collect(_id : int):
	if id == _id:
		queue_free()
