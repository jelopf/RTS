extends CharacterBody3D

var is_busy = false
var is_processing_mining = false
var target_position: Vector3
var mining_target = null

@export var speed := 3.0

func start_mining(resource_node):
	if is_busy:
		return # Юнит уже занят
	is_busy = true
	mining_target = resource_node
	target_position = resource_node.global_transform.origin

func _physics_process(_delta):
	if is_busy and mining_target and not is_processing_mining:
		var direction = (target_position - global_transform.origin).normalized()
		velocity = direction * speed
		move_and_slide()

		if global_transform.origin.distance_to(target_position) < 2.0:
			velocity = Vector3.ZERO
			start_mining_process()

func start_mining_process():
	is_processing_mining = true
	print("Начало добычи! Ждём ", mining_target.mining_time, " секунд.")

	# Инициализация и запуск добычи через руду
	await mining_target.mine()

	# Завершаем процесс добычи
	is_busy = false
	is_processing_mining = false
	mining_target = null
	print("Добыча завершена! Юнит снова свободен.")
