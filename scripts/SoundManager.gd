# SoundManager.gd

extends Node

# 2D звук
func play_2d(sound: AudioStream):
	if sound == null:
		return
	var player = AudioStreamPlayer.new()
	player.stream = sound
	get_tree().root.add_child(player)  
	player.play()
	player.connect("finished", player.queue_free)

# 3D звук 
func play_3d(sound: AudioStream, position: Vector3):
	if sound == null:
		return
	var player = AudioStreamPlayer3D.new()
	player.stream = sound
	
	# Всегда добавляем в корень текущей сцены
	var current_scene = get_tree().current_scene
	current_scene.add_child(player)
	
	player.global_transform.origin = position
	player.play()
	player.connect("finished", player.queue_free)
