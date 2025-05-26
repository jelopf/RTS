extends Node

var metal := 100
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

func create_barracks(position: Vector3):
	var data = get_selected_barracks_data()
	if data.is_empty():
		print("Ошибка: нет данных для текущего типа казармы")
		return
	
	if not spend_metal(data["cost"]):
		return

	var barracks = preload("res://scenes/objects/Barracks.tscn").instantiate()
	barracks.hp = data["hp"]
	barracks.unit_count = data["unit_count"]
	barracks.global_transform.origin = position
	get_tree().current_scene.add_child(barracks)
	print("Казарма создана с HP: ", data["hp"], ", юнитов: ", data["unit_count"])

func start_combat_phase():
	combat_active = true
	set_resources_interactive(false)
	var resources = get_tree().get_nodes_in_group("resource")
	for res in resources:
		if res.has_method("deactivate"):
			res.deactivate()
	# Останавливаем добычу у всех юнитов
	var units = get_tree().get_nodes_in_group("unit")
	for u in units:
		if u.has_method("interrupt_mining"):
			u.interrupt_mining()


func end_combat_phase():
	combat_active = false
	set_resources_interactive(true)
	print("Боевая фаза завершена! Ресурсы снова доступны.")
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
