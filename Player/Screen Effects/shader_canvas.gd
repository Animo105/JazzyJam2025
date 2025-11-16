extends CanvasLayer
class_name CameraEffetcs
@onready var texture_rect_ball: TextureRect = $TextureRect
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D

var ballpit_tween : Tween

var ball_effect : bool = false:
	set(value):
		if ballpit_tween:
			ballpit_tween.kill()
		ballpit_tween = create_tween()
		if value:
			ballpit_tween.tween_property(texture_rect_ball, "offset_top", 0, 0.2)
		else:
			ballpit_tween.tween_property(texture_rect_ball, "offset_top", 961, 0.2) #961 = taille de l'image de balles

func _ready() -> void:
	texture_rect_ball.offset_top = 961
