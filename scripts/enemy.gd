extends CharacterBody3D

@export var speed := 3.0  # Скорость движения
var target_base: Node3D  # Ссылка на базу

func _ready():
	print("Враг загружен! Начальная позиция:", global_transform.origin)
	
	# Проверим, правильно ли мы получаем ссылку на базу
	target_base = get_tree().get_current_scene().get_node("Base")
	if target_base:
		print("Цель (база) получена:", target_base.global_transform.origin)  # Печатаем позицию базы
	else:
		print("Ошибка: база не найдена!")

func _physics_process(_delta):
	if target_base:
		move_towards_base()
	else:
		print("Нет цели для движения.")  # Если цели нет, печатаем это сообщение

func move_towards_base():
	var direction = (target_base.global_transform.origin - global_transform.origin).normalized()
	velocity = direction * speed
	print("Moving towards base. Direction:", direction, " Velocity:", velocity)
	move_and_slide()
