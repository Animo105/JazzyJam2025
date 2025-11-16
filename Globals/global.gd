extends Node
signal plushCollected(id : int)
signal lookingAtPlush(looking : bool)
signal message(text : String)
signal is_chasing(enable : bool)
signal is_hiding()

const WIN_AMOUNT_PLUSHIES : int = 3

var nbPlushCollected : int = 0

const mouse_sensitivity : float = 0.2

func _ready() -> void:
	plushCollected.connect(collect)

func collect(_id : int):
	nbPlushCollected += 1
	if nbPlushCollected >= WIN_AMOUNT_PLUSHIES:
		MusicPanel.clear_music()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		MusicPanel.play_you_win()
		nbPlushCollected = 0
		get_tree().call_deferred("change_scene_to_file",  "res://Menus/Start menu.tscn")
