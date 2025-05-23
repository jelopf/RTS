extends Node3D

@onready var shop_menu = $UI/ShopMenu  # Убедись, что путь совпадает с названием узла
@onready var wave_manager = $WaveManager

func _ready():
	wave_manager.configure([3, 3, 5] as Array[int], 60.0, 30.0) # Настройки первого уровня
	
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_M:
		toggle_shop_menu()

func toggle_shop_menu():
	if shop_menu:
		shop_menu.visible = not shop_menu.visible
