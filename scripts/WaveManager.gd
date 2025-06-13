# WaveManager.gd

extends Node

@export var preparation_time := 30.0
@export var break_time := 5.0
@export var waves: Array = [1, 3, 5]  
var ui: Node = null


var current_wave := 0
var is_active := false 

func _ready():
	await get_tree().create_timer(0.1).timeout
	
	if AudioLibrary and AudioLibrary.bg_music:
		MusicManager.play_music(AudioLibrary.bg_music)
		
	start_preparation_phase()

func start_preparation_phase():
	print("Подготовка! У вас есть ", preparation_time, " секунд.")
	await get_tree().create_timer(preparation_time).timeout
	start_next_wave()

func start_wave(index: int) -> void:
	if index >= waves.size():
		print("Все волны завершены!")
		return
	
	current_wave = index
	update_wave_label()
	var enemy_count = waves[index]

	print("Волна ", index + 1, " начинается! Противников: ", enemy_count)
	if GameManager.has_method("start_combat_phase"):
		GameManager.start_combat_phase()

	spawn_enemies(enemy_count)


func start_next_wave():
	if current_wave >= waves.size():
		print("Все волны завершены!")
		return
	
	start_wave(current_wave)
	await wait_for_wave_to_end()

	if GameManager.has_method("end_combat_phase"):
		GameManager.end_combat_phase()

	current_wave += 1  

	if current_wave < waves.size():
		print("Перерыв ", break_time, " секунд.")
		await get_tree().create_timer(break_time).timeout
		start_preparation_phase()
	else:
		print("Вы победили все волны!")
		GameManager.show_victory_screen()

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
	
func configure(params: Dictionary):
	preparation_time = params.get("preparation_time", 60.0)
	break_time = params.get("break_time", 30.0)
	waves = params.get("waves", [])
	ui = params.get("ui", null)

	
func update_wave_label():
	ui.set_wave_text("Волна: %d / %d" % [current_wave + 1, waves.size()])
		
	
	
