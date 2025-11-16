extends StaticBody3D

@onready var enter_sfx: AudioStreamPlayer = $enter_sfx
var player_in : bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		print("in")
		if !player_in:
			player_in = true
			play_enter_sound()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		print("out")
		if player_in:
			player_in = false
			play_enter_sound()
			


func play_enter_sound():
	enter_sfx.pitch_scale = randf()*0.2 + 0.7
	enter_sfx.play()
