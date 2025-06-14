# resource.gd

extends Node3D

@export var metal_amount := 5
@export var regen_time := 10.0
@export var mining_time := 5.0

var is_available := true
var _is_clickable = true
var mining_progress := 0.0
var mining_bar: ProgressBar = null
var progress_bar_instance: Control = null
var timer_label: Label = null
var mesh: Node3D = null 


func _ready():
	mining_bar = $CanvasLayer/Control/ProgressBar
	if mining_bar == null:
		print("Ошибка: Прогрессбар не найден!")
		return
	add_to_group("resource")


	timer_label = $CanvasLayer/Control/Label
	if timer_label == null:
		print("Ошибка: Лейбл не найден!")
		return

	mesh = $"."  

	mining_bar.visible = false
	progress_bar_instance = mining_bar.get_parent()

func mine():
	if GameManager.is_combat_active():
		print("Сейчас фаза боя, добыча невозможна!")
		return

	if is_available:
		is_available = false
		mining_progress = 0.0
		show_progress_bar()
		await update_progress_bar()
		
		if not GameManager.is_combat_active():
			give_metal()
		
		hide_resource()
		start_regen()



func give_metal():
	GameManager.add_metal(metal_amount)
	print("Игрок получил ", metal_amount, " металла!")

func start_regen():
	await get_tree().create_timer(regen_time).timeout

	while GameManager.is_combat_active():
		await get_tree().create_timer(1.0).timeout
	

	is_available = true
	show_resource()
	print("Руда восстановилась!")


func hide_resource():
	if mesh:
		mesh.visible = false
	visible = false  

func show_resource():
	if mesh:
		mesh.visible = true
	visible = true

func on_clicked():
	if is_available:
		print("Руда выбрана для добычи!")
		assign_unit_to_mine()
	else:
		print("Руда пока недоступна!")

func assign_unit_to_mine():
	var units = get_tree().get_nodes_in_group("unit")
	var closest_unit = null
	var closest_distance = INF

	for unit in units:
		if unit.is_busy or unit.is_processing_mining or unit.is_dead():
			continue
		var distance = global_transform.origin.distance_to(unit.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			closest_unit = unit

	if closest_unit:
		print("Ближайший юнит отправлен на добычу!")
		closest_unit.start_mining(self)
	else:
		print("Нет свободных юнитов для добычи.")

func show_progress_bar():
	mining_bar.visible = true
	mining_bar.value = 0
	timer_label.visible = true 
	timer_label.text = str(mining_time) + " секунд"
	update_progress_bar()


func update_progress_bar() -> void:
	var elapsed = 0.0
	var step = 0.1
	var target_position = global_transform.origin

	while elapsed < mining_time:
		if GameManager.is_combat_active():
			print("Фаза боя началась во время добычи!")
			hide_progress_bar()
			hide_resource()
		mining_bar.value = (elapsed / mining_time) * 100
		timer_label.text = str(round(mining_time - elapsed)) + " секунд"
		update_bar_position(target_position)
		await get_tree().create_timer(step).timeout
		elapsed += step
	
	mining_bar.value = 100
	timer_label.text = "Готово!"
	update_bar_position(target_position)

	await get_tree().create_timer(0.5).timeout
	hide_progress_bar()



func update_bar_position(target_position):
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return
	var screen_position = camera.unproject_position(target_position)
	progress_bar_instance.position = Vector2(screen_position.x, screen_position.y - 50)


func hide_progress_bar():
	mining_bar.visible = false
	mining_bar.value = 0
	timer_label.visible = false
	mining_time = 5.0
	
	

func deactivate():
	if is_available:
		is_available = false
		hide_resource()
		hide_progress_bar()
		print("Ресурс временно отключён.")
		
func is_clickable():
	return _is_clickable

func set_interactive(value: bool):
	_is_clickable = value
