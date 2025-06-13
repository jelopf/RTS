# GameManager.gd

extends Node

var metal := 10
var selected_barracks_type := 1  # По умолчанию тип 1
var combat_active := false
var ui_node: Node = null

# Таблица с характеристиками казарм
var barracks_data = {
	1: {
		"hp": 100,
		"units": 1,
		"cost": 3,
		"scene_path": "res://scenes/objects/Barracks1.tscn"
	},
	2: {
		"hp": 175,
		"units": 3,
		"cost": 7,
		"scene_path": "res://scenes/objects/Barracks2.tscn"
	},
	3: {
		"hp": 250,
		"units": 5,
		"cost": 10,
		"scene_path": "res://scenes/objects/Barracks3.tscn"
	}
}

var levels = [
	"res://scenes/levels/Level1.tscn",
	"res://scenes/levels/Level2.tscn",
	"res://scenes/levels/Level3.tscn"
]

func get_next_level_path() -> String:
	var current = get_tree().current_scene.scene_file_path
	var index = levels.find(current)
	if index >= 0 and index + 1 < levels.size():
		return levels[index + 1]
	return ""  # Больше нет уровней
	

var ghost_building := false  # Флаг: в режиме предпросмотра или нет

func set_ui(ui: Node):
	ui_node = ui
	if ui_node:
		ui_node.set_metal_count("Металл: %d" % metal)

func add_metal(amount: int):
	metal += amount
	if ui_node:
		ui_node.set_metal_count("Металл: %d" % metal)

func spend_metal(amount: int) -> bool:
	if metal >= amount:
		metal -= amount
		if ui_node:
			ui_node.set_metal_count("Металл: %d" % metal)
		return true
	return false

func set_selected_barracks_type(type: int):
	if barracks_data.has(type):
		selected_barracks_type = type
		print("Выбран тип казармы: ", type)

func get_selected_barracks_data() -> Dictionary:
	return barracks_data.get(selected_barracks_type, {})

func get_selected_barracks_cost() -> int:
	return get_selected_barracks_data().get("cost", 999)


func create_barracks_instance(type: int = -1) -> Node:
	var t = type if type != -1 else selected_barracks_type
	var data = barracks_data.get(t, {})
	if data.is_empty():
		print("Ошибка: нет данных для типа казармы ", t)
		return null
	
	if not spend_metal(data["cost"]):
		return null
	
	var scene = load(data["scene_path"])
	var barracks = scene.instantiate()
	barracks.add_to_group("barracks")
	barracks.hp = data["hp"]
	barracks.unit_count = data["units"]
	return barracks


func start_combat_phase():
	combat_active = true
	set_resources_interactive(false)
	var resources = get_tree().get_nodes_in_group("resource")
	for res in resources:
		if res.has_method("deactivate"):
			res.deactivate()
	var units = get_tree().get_nodes_in_group("unit")
	for u in units:
		if u.has_method("interrupt_mining"):
			u.interrupt_mining()


func end_combat_phase():
	combat_active = false
	set_resources_interactive(true)
	var resources = get_tree().get_nodes_in_group("resource")
	for resource in resources:
		if resource.has_method("show_resource"):
			resource.show_resource()
			resource.is_available = true


func is_combat_active() -> bool:
	return combat_active


func set_resources_interactive(enabled: bool):
	var resources = get_tree().get_nodes_in_group("resource")
	for res in resources:
		if res.has_method("set_interactive"):
			res.set_interactive(enabled)
			
			
func check_game_over():
	var units = get_tree().get_nodes_in_group("unit")
	var barracks = get_tree().get_nodes_in_group("barracks")
	
	var has_units = false
	for unit in units:
		if unit.is_inside_tree() and not unit.is_dead():
			has_units = true
			break

	var has_barracks = false
	for barrack in barracks:
		if barrack.is_inside_tree() and not barrack.is_queued_for_deletion():
			has_barracks = true
			break

	if not has_units and not has_barracks:
		game_over()


func game_over():
	print("Игра окончена! Все юниты и казармы уничтожены.")
	metal = 0
	show_game_over_screen()


func show_game_over_screen():
	MusicManager.stop_music()
	var screen = get_tree().current_scene.get_node_or_null("UI/DefeatScreen")
	if screen:
		screen.visible = true
	else:
		print("DefeatScreen не найден в UI!")


func show_victory_screen():
	MusicManager.stop_music()
	var screen = get_tree().current_scene.get_node_or_null("UI/VictoryScreen")
	if screen:
		screen.visible = true
	else:
		print("VictoryScreen не найден в UI!")


var selected_units: Array = []

func get_selected_units() -> Array:
	return selected_units

func set_selected_units(units: Array) -> void:
	selected_units = units
	
