extends Area3D
class_name plush


@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var area_3d: Area3D = $Area3D

var pickup : bool = false

func _physics_process(_delta: float) -> void:
	pass

func _on_area_3d_area_entered(area: Area3D) -> void:
	mesh_instance_3d.visible = false
	pickup = true
	print(pickup)
