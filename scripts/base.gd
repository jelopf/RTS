extends Area3D

@export var max_health := 100
var current_health := max_health

var health_bar: ProgressBar = null
var progress_bar_instance: Control = null
var mesh: Node3D = null  # визуальный меш базы

func _ready():
	current_health = max_health

	# Получаем ссылки на элементы UI
	health_bar = $CanvasLayer/Control/ProgressBar
	if health_bar == null:
		print("Ошибка: Прогрессбар не найден!")
		return

	progress_bar_instance = health_bar.get_parent()

	mesh = $MeshInstance3D  # замени на правильный путь, если нужно

	health_bar.visible = true
	update_health_bar()
	update_bar_position(global_transform.origin)

func take_damage(amount):
	current_health -= amount
	#print("Базе нанесён урон:", amount, "Осталось здоровья:", current_health)
	
	update_health_bar()

	if current_health <= 0:
		die()

func update_health_bar():
	if health_bar:
		var percent := float(current_health) / float(max_health) * 100.0
		health_bar.value = percent
		update_bar_position(global_transform.origin)

func update_bar_position(target_position):
	var screen_position = get_viewport().get_camera_3d().unproject_position(target_position)
	progress_bar_instance.position = Vector2(screen_position.x, screen_position.y - 50)

func die():
	print("База разрушена!")
	queue_free()
