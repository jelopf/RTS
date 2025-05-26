extends Control

@onready var level_select_panel = $LevelSelectPanel

func _ready():
	level_select_panel.visible = false

func _on_play_pressed():
	level_select_panel.visible = true

func _on_exit_pressed():
	get_tree().quit()

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/Level1.tscn")

func _on_level_2_pressed():
	# Можно добавить проверку разблокировки
	get_tree().change_scene_to_file("res://scenes/levels/Level2.tscn")

func _on_level_3_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/Level3.tscn")
