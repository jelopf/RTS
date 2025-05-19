extends Node

var metal := 10
var selected_barracks_type := 1  # По умолчанию тип 1


# Таблица с характеристиками казарм
var barracks_data = {
	1: {
		"hp": 100,
		"units": 1,
		"cost": 3,
		"scene_path": "res://scenes/Barracks1.tscn"
	},
	2: {
		"hp": 175,
		"units": 3,
		"cost": 7,
		"scene_path": "res://scenes/Barracks2.tscn"
	},
	3: {
		"hp": 250,
		"units": 5,
		"cost": 10,
		"scene_path": "res://scenes/Barracks3.tscn"
	}
}

var ghost_building := false  # Флаг: в режиме предпросмотра или нет


func add_metal(amount: int):
	metal += amount
	print("Металл теперь: ", metal)

func spend_metal(amount: int) -> bool:
	if metal >= amount:
		metal -= amount
		print("Потрачено! Осталось металла: ", metal)
		return true
	print("Недостаточно металла!")
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

	var barracks = preload("res://scenes/Barracks.tscn").instantiate()
	barracks.hp = data["hp"]
	barracks.unit_count = data["unit_count"]
	barracks.global_transform.origin = position
	get_tree().current_scene.add_child(barracks)
	print("Казарма создана с HP: ", data["hp"], ", юнитов: ", data["unit_count"])
