extends Control

@onready var next_button = $VBoxContainer/NextLevelButton
@onready var menu_button = $VBoxContainer/MainMenuButton

func _ready():
	visible = false  # Скрыт по умолчанию

func _on_next_pressed():
	var next_level_path = GameManager.get_next_level_path()
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)
	else:
		get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")
