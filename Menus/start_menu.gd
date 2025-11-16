extends Control

@onready var animation_player: AnimationPlayer = $Node3D/JazzyTonic2/AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $Menu/Help/AudioStreamPlayer

func _ready() -> void:
	MusicPanel.plays_menu_music(true)
	animation_player.play("Dance")

func _on_start_pressed() -> void:
	MusicPanel.plays_menu_music(false)
	get_tree().change_scene_to_file("res://world.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_help_pressed() -> void:
	audio_stream_player.play()


func _on_quit_pressed() -> void:
	get_tree().quit()
