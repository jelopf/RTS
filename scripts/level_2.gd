# level_2.gd

extends Node3D

@onready var shop_menu = $UI/ShopMenu/ShopMenu 
@onready var wave_manager = $WaveManager
@onready var ui = $UI/LevelUI

func _ready():
	wave_manager.configure({
	"waves": [3, 3, 5],
	"preparation_time": 10.0,
	"break_time": 10.0,
	"ui": ui
})
	GameManager.set_ui(ui)
	
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_M:
		toggle_shop_menu()

func toggle_shop_menu():
	if shop_menu:
		shop_menu.visible = not shop_menu.visible
		
func on_next_level_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/Level3.tscn")
