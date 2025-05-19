extends CharacterBody3D

@export var speed := 3.0
@export var attack_range := 1.5
@export var attack_damage := 10
@export var attack_interval := 1.0  # как часто наносим урон

var target_base: Node3D
var is_attacking := false

func _ready():
	print("Враг загружен! Позиция:", global_transform.origin)
	target_base = get_tree().get_current_scene().get_node("Base")
	if target_base:
		print("База найдена:", target_base.global_transform.origin)
	else:
		print("Ошибка: база не найдена!")

func _physics_process(_delta):
	if target_base and not is_attacking:
		var distance = global_transform.origin.distance_to(target_base.global_transform.origin)
		if distance > attack_range:
			move_towards_base()
		else:
			start_attacking()

func move_towards_base():
	var direction = (target_base.global_transform.origin - global_transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()

func start_attacking():
	is_attacking = true
	velocity = Vector3.ZERO
	attack_loop()

func attack_loop() -> void:
	if not target_base:
		print("Базы нет. Прекращаем атаку.")
		queue_free()
		return

	if not is_instance_valid(target_base):
		print("База уничтожена.")
		queue_free()
		return

	target_base.take_damage(attack_damage)
	# print("Враг атакует! Урон:", attack_damage)

	# Ждём паузу и атакуем снова
	await get_tree().create_timer(attack_interval).timeout
	attack_loop()
