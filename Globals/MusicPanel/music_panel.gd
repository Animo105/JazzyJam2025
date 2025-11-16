extends Node

@onready var _music_menu: AudioStreamPlayer = $"Music Menu"
@onready var _chase_music: AudioStreamPlayer = $"Chase Music"
@onready var _power_out: AudioStreamPlayer = $"SFX/Power Out"

const NO_SOUND_DB = -40

func _ready() -> void:
	Power.on_power_update.connect(_power_outage)
	_music_menu.autoplay = true
	Global.is_chasing.connect(_enable_chase_music)
	_chase_music.autoplay = true
	_chase_music.volume_db = NO_SOUND_DB

func plays_menu_music(enable : bool = true)->void:
	if enable:
		_music_menu.play()
	else:
		_music_menu.stop()

func _enable_chase_music(enable : bool)->void:
	var tween : Tween = create_tween()
	if (enable):
		_chase_music.play()
		tween.tween_property(_chase_music, "volume_db", 0, 1)
	else:
		tween.tween_property(_chase_music, "volume_db", NO_SOUND_DB, 1)
		await tween.finished
		_chase_music.stop()

func _power_outage(value : int)->void:
	if value <= 0:
		_power_out.play()

func clear_music():
	_music_menu.stop()
	_chase_music.stop()
