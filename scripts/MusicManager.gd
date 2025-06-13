# MusicManager.gd

extends Node

var music_player: AudioStreamPlayer = null

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)

func play_music(music: AudioStream):
	if music == null:
		return
	if music_player.stream == music and music_player.playing:
		return  
	music_player.stop()
	music_player.volume_linear = 0.5
	music_player.stream = music
	music_player.play()


func stop_music():
	music_player.stop()
