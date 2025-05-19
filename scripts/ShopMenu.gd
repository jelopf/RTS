extends Control

func _ready():
	$PanelContainer/VBoxContainer/Button1.pressed.connect(_on_type_1_pressed)
	$PanelContainer/VBoxContainer/Button2.pressed.connect(_on_type_2_pressed)
	$PanelContainer/VBoxContainer/Button3.pressed.connect(_on_type_3_pressed)

func _on_type_1_pressed():
	PlacementManager.start_placement(1)
	visible = false  # прячем сам магазин

func _on_type_2_pressed():
	PlacementManager.start_placement(2)
	visible = false

func _on_type_3_pressed():
	PlacementManager.start_placement(3)
	visible = false

func _on_open_shop_button_pressed():
	var shop_menu = $ShopMenu  # если ShopMenu рядом с кнопкой
	shop_menu.visible = not shop_menu.visible
