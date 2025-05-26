extends Control

@onready var retry_button = $VBoxContainer/RetryButton
@onready var menu_button = $VBoxContainer/MainMenuButton

func _ready():
	visible = false  # скрыт по умолчанию

func _on_retry_pressed():
	var current_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene_path)

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")
