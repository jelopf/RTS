extends Node

@export var preparation_time := 1.0
@export var break_time := 5.0
@export var waves: Array[int] = [1, 3, 5]  # Пример: [[3], [3], [5]]

var current_wave := 0
var is_active := false
var player_base: Node3D  # Ссылка на базу игрока

func _ready():
	# Безопасное ожидание, чтобы убедиться, что сцена готова
	await get_tree().create_timer(0.1).timeout  # Немного ждем перед тем, как найти базу

	# Путь к базе - ищем по родительскому узлу, предполагаем, что база находится в родительской сцене
	player_base = get_parent().get_node("Base")  # Можно попробовать заменить на правильный путь
	if player_base:
		print("База игрока найдена!")
	else:
		print("Ошибка: база не найдена!")

	start_preparation_phase()

func start_preparation_phase():
	print("Подготовка! У вас есть ", preparation_time, " секунд.")
	await get_tree().create_timer(preparation_time).timeout
	start_next_wave()

func start_next_wave():
	if current_wave >= waves.size():
		print("Все волны завершены!")
		return

	var enemy_count = waves[current_wave]
	print("Волна ", current_wave + 1, " начинается! Противников: ", enemy_count)
	spawn_enemies(enemy_count)

	current_wave += 1
	await wait_for_wave_to_end()
	if current_wave < waves.size():
		print("Перерыв ", break_time, " секунд.")
		await get_tree().create_timer(break_time).timeout
		start_next_wave()
	else:
		print("Вы победили все волны!")

func spawn_enemies(count):
	for i in range(count):
		var enemy = preload("res://scenes/Enemy.tscn").instantiate()
		# Добавляем врага в сцену
		get_parent().add_child(enemy)
		# Теперь задаем позицию после того, как враг добавлен в сцену
		enemy.global_transform.origin = get_random_spawn_position()
		# Печать для отладки
		print("Враг добавлен в сцену на позиции:", enemy.global_transform.origin)

func wait_for_wave_to_end():
	while get_tree().get_nodes_in_group("enemy").size() > 0:
		await get_tree().create_timer(1.0).timeout

func get_random_spawn_position():
	# Возвращаем случайную точку спавна
	return Vector3(-9.0, 0.0, 0.0)
