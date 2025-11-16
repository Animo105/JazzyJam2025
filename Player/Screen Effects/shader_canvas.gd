extends CanvasLayer
class_name CameraEffetcs
@onready var texture_rect_ball: TextureRect = $TextureRect

var ballpit_tween : Tween

var ball_effect : bool = false:
	set(value):
		if ballpit_tween:
			ballpit_tween.kill()
		ballpit_tween = create_tween()
		if value:
			ballpit_tween.tween_property(texture_rect_ball, "offset_top", 0, 0.1)
		else:
			ballpit_tween.tween_property(texture_rect_ball, "offset_top", 446, 0.1) #446 = taille de l'image de balles

func _ready() -> void:
	texture_rect_ball.offset_top = 961
