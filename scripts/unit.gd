# unit.gd

extends CharacterBody3D

var is_busy = false
var is_processing_mining = false
var target_position: Vector3
var mining_target = null
var attack_target = null
var is_attacking = false
var ready_to_attack = false
var is_dead_flag = false 
var manual_attack_target := false


@export var speed := 2.0
@export var hp := 15
@export var attack_range := 3.0
@export var attack_damage := 5
@export var attack_interval := 3.0

func _ready():
	add_to_group("targetable")
	add_to_group("unit")

func start_mining(resource_node):
	if is_busy:
		return
	is_busy = true
	mining_target = resource_node
	var raw_pos = resource_node.global_transform.origin
	target_position = Vector3(raw_pos.x, 0.5, raw_pos.z)

func _physics_process(_delta):
	if is_attacking:

		if not is_instance_valid(attack_target):
			is_attacking = false
			is_busy = false
			attack_target = null
			ready_to_attack = false
			return

		var distance = global_transform.origin.distance_to(attack_target.global_transform.origin)

		if distance > attack_range:
			var direction = (attack_target.global_transform.origin - global_transform.origin).normalized()
			velocity = direction * speed
			move_and_slide()
		else:
			velocity = Vector3.ZERO
			if not ready_to_attack:
				ready_to_attack = true
				attack_loop()
		return

	if is_busy and mining_target and not is_processing_mining:
		var direction = (target_position - global_transform.origin).normalized()
		velocity = direction * speed
		move_and_slide()
	

		if global_transform.origin.distance_to(target_position) < 2.0:
			velocity = Vector3.ZERO
			start_mining_process()

	if not is_busy and not is_processing_mining and not is_attacking:
		if not attack_target and not manual_attack_target:
			var nearest = find_nearest_enemy()
			if nearest:
				attack_target = nearest
				start_attack()


func start_mining_process():
	if GameManager.is_combat_active():
		print("Фаза боя: добыча отменена.")
		is_busy = false
		is_processing_mining = false
		if mining_target:
			mining_target.hide_progress_bar()
		mining_target = null
		return

	is_processing_mining = true
	print("Начало добычи! Ждём ", mining_target.mining_time, " секунд.")

	await mining_target.mine()

	is_busy = false
	is_processing_mining = false
	mining_target = null
	print("Добыча завершена! Юнит снова свободен.")

func take_damage(amount: int, attacker: Node3D = null):
	if is_dead_flag:
		return

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
		is_dead_flag = true
		queue_free()
		GameManager.check_game_over()

func start_attack():
	if not attack_target or is_attacking:
		return
	is_attacking = true
	is_busy = true
	ready_to_attack = false
	target_position = attack_target.global_transform.origin


func attack_loop():
	if not is_instance_valid(attack_target):
		print("Цель уничтожена.")
		is_attacking = false
		is_busy = false
		attack_target = null
		manual_attack_target = false
		return

	if global_transform.origin.distance_to(attack_target.global_transform.origin) > attack_range:
		return

	if attack_target.has_method("take_damage"):
		attack_target.take_damage(attack_damage)

	await get_tree().create_timer(attack_interval).timeout
	attack_loop()

func interrupt_mining():
	if is_processing_mining:
		is_busy = false
		is_processing_mining = false
		if mining_target:
			mining_target.hide_progress_bar()
		mining_target = null
		print("Добыча прервана. Юнит возвращён в боевую готовность.")

func find_nearest_enemy() -> Node3D:
	var nearest_enemy = null
	var min_dist = INF
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy):
			continue
		var dist = global_transform.origin.distance_to(enemy.global_transform.origin)
		if dist < min_dist:
			min_dist = dist
			nearest_enemy = enemy
	return nearest_enemy
	
func is_dead() -> bool:
	return hp <= 0 or not is_inside_tree()

func set_attack_target(target: Node3D):
	if is_dead_flag or not is_instance_valid(target):
		return

	# Прерываем текущую атаку
	is_attacking = false
	ready_to_attack = false
	attack_target = null

	interrupt_mining()  # Остановим добычу
	attack_target = target
	manual_attack_target = true
	start_attack()
