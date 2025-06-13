# audio_library.gd

extends Node

@export var sfx_player_action: AudioStream
@export var sfx_build_barracks: AudioStream
@export var sfx_unit_spawn: AudioStream
@export var sfx_combat: AudioStream
@export var bg_music: AudioStream

func _ready():
	print("AudioLibrary загружена.")
