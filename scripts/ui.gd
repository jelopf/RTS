extends Control

func show_next_level_button():
	$NextLevelButton.visible = true

func _on_NextLevelButton_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/Level2.tscn")  # Для второго уровня

func set_wave_text(text: String):
	$WaveLabel.text = text
