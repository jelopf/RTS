# ClickSoundManager.gd

extends Node

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SoundManager.play_2d(AudioLibrary.sfx_player_action)
