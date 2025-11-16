extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPanel.clear_music()
	animation_player.play("death")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://Menus/Start menu.tscn")
