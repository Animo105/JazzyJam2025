extends Control

@onready var WORLD = load("uid://j6rvkritji5c")
@onready var audio_stream_player: AudioStreamPlayer = $Menu/Help/AudioStreamPlayer
@onready var menu_music: AudioStreamPlayer = $"menu music"

func _ready() -> void:
	menu_music.autoplay = true
	menu_music.play()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	


func _on_help_pressed() -> void:
	audio_stream_player.play()


func _on_quit_pressed() -> void:
	get_tree().quit()
