# enemy.gd

extends CharacterBody3D

@export var speed := 1.0
@export var attack_range := 3
@export var attack_damage := 5
@export var attack_interval := 3.0
@export var hp := 15

var current_target: Node3D = null
var is_attacking := false

func _ready():
	print("Враг загружен!")
	find_target()
	$CombatAudio.stream = AudioLibrary.sfx_combat

func _physics_process(_delta):
	if not is_attacking:
		find_target()

	if current_target and not is_attacking:
		var distance = global_transform.origin.distance_to(current_target.global_transform.origin)
		if distance > attack_range:
			move_towards(current_target)
		else:
			start_attacking()

func move_towards(target):
	var target_pos = target.global_transform.origin
	target_pos.y = 0.5  # Принудительно по земле

	var direction = (target_pos - global_transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()


func start_attacking():
	is_attacking = true
	velocity = Vector3.ZERO
	attack_loop()

func attack_loop() -> void:
	if not is_instance_valid(current_target) or is_queued_for_deletion():
		is_attacking = false
		find_target()
		return

	if current_target.has_method("take_damage"):
		# Воспроизводим звук атаки с позицией врага
		SoundManager.play_3d(AudioLibrary.sfx_combat, global_transform.origin)
		
		current_target.take_damage(attack_damage, self)
	else:
		# Если цель не имеет метода take_damage, прекращаем атаку
		is_attacking = false
		return

	# Ожидаем интервал и повторяем
	await get_tree().create_timer(attack_interval).timeout
	attack_loop()  # Рекурсивный вызов для следующей атаки

func find_target():
	var min_dist = INF
	var closest = null
	var my_position = global_transform.origin

	for target in get_tree().get_nodes_in_group("targetable"):
		if not is_instance_valid(target):
			continue
		var dist = my_position.distance_to(target.global_transform.origin)
		if dist < min_dist:
			min_dist = dist
			closest = target

	if closest:
		current_target = closest

func take_damage(amount: int, _attacker: Node3D = null):
	hp -= amount
	print("Враг получил урон:", amount, " Осталось HP:", hp)

	if hp <= 0:
		print("Враг уничтожен!")
		queue_free()

func on_clicked():
	print("Враг был выбран как цель!")
	var units = get_tree().get_nodes_in_group("unit")
	for unit in units:
		if is_instance_valid(unit) and not unit.is_busy and not unit.is_attacking:
			unit.attack_target = self
			unit.start_attack()
			break 
