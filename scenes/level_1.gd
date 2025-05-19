extends Node3D

@onready var shop_menu = $UI/ShopMenu  # Убедись, что путь совпадает с названием узла

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_M:
		toggle_shop_menu()

func toggle_shop_menu():
	if shop_menu:
		shop_menu.visible = not shop_menu.visible
