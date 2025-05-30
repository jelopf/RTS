extends Node

@export var preparation_time := 30.0
@export var break_time := 5.0
@export var waves: Array = [1, 3, 5]  # Пример: [[3], [3], [5]]
var ui: Node = null


var current_wave := 0
var is_active := false
var player_base: Node3D  # Ссылка на базу игрока

func _ready():
	# Безопасное ожидание, чтобы убедиться, что сцена готова
	await get_tree().create_timer(0.1).timeout
	start_preparation_phase()

func start_preparation_phase():
	print("Подготовка! У вас есть ", preparation_time, " секунд.")
	await get_tree().create_timer(preparation_time).timeout
	start_next_wave()

func start_next_wave():
	if current_wave >= waves.size():
		print("Все волны завершены!")
		return
	
	update_wave_label()  
	var enemy_count = waves[current_wave]
	print("Волна ", current_wave + 1, " начинается! Противников: ", enemy_count)
	

	

	if GameManager.has_method("start_combat_phase"):
		GameManager.start_combat_phase()

	spawn_enemies(enemy_count)
	current_wave += 1  # увеличиваем после спавна, чтобы в будущем была корректная проверка

	await wait_for_wave_to_end()

	if GameManager.has_method("end_combat_phase"):
		GameManager.end_combat_phase()
		
		

	if current_wave < waves.size():
		print("Перерыв ", break_time, " секунд.")
		await get_tree().create_timer(break_time).timeout
		start_preparation_phase()
	else:
		print("Вы победили все волны!")
		GameManager.show_victory_screen()
		

		# Проверка и вызов UI кнопки
		if ui and ui.has_method("show_next_level_button"):
			ui.show_next_level_button()



func spawn_enemies(count):
	for i in range(count):
		var enemy = preload("res://scenes/humanoids/Enemy.tscn").instantiate()
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
	return Vector3(randf_range(-5, 5), 0.5, 0.0)
	
func configure(waves_config: Array, preparation: float = 60.0, pause: float = 30.0, ui_node: Node = null):
	preparation_time = preparation
	break_time = pause
	waves = waves_config
	ui = ui_node
	
func update_wave_label():
	ui.set_wave_text("Волна: %d / %d" % [current_wave + 1, waves.size()])
		
	
	
