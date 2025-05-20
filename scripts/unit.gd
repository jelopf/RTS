extends CharacterBody3D

var is_busy = false
var is_processing_mining = false
var target_position: Vector3
var mining_target = null
var attack_target = null
var is_attacking = false

@export var speed := 3.0
@export var hp := 25
@export var attack_range := 2.0
@export var attack_damage := 4
@export var attack_interval := 3.0  # Каждые 3 секунды

func _ready():
	add_to_group("targetable")

func start_mining(resource_node):
	if is_busy:
		return # Юнит уже занят
	is_busy = true
	mining_target = resource_node
	target_position = resource_node.global_transform.origin

func _physics_process(_delta):
	if is_attacking:
		# Атакующий юнит не должен двигаться
		velocity = Vector3.ZERO
		return

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

	await mining_target.mine()

	is_busy = false
	is_processing_mining = false
	mining_target = null
	print("Добыча завершена! Юнит снова свободен.")

func take_damage(amount: int, attacker: Node3D = null):
	hp -= amount
	print("Юнит получил урон:", amount, " Осталось HP:", hp)

	# Остановим добычу и начнём защищаться
	is_busy = false
	is_processing_mining = false
	mining_target = null

	if attacker != null:
		attack_target = attacker
		start_attack()

	if hp <= 0:
		queue_free()

func start_attack():
	if not attack_target or is_attacking:
		return

	is_attacking = true
	velocity = Vector3.ZERO
	attack_loop()

func attack_loop():
	if not is_instance_valid(attack_target):
		print("Цель уничтожена.")
		is_attacking = false
		attack_target = null
		return

	if global_transform.origin.distance_to(attack_target.global_transform.origin) > attack_range:
		print("Цель слишком далеко. Останавливаем атаку.")
		is_attacking = false
		attack_target = null
		return

	# Атака цели
	if attack_target.has_method("take_damage"):
		attack_target.take_damage(attack_damage)

	await get_tree().create_timer(attack_interval).timeout
	attack_loop()
