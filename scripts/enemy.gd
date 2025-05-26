extends CharacterBody3D

@export var speed := 1.0
@export var attack_range := 1.5
@export var attack_damage := 4
@export var attack_interval := 3.0
@export var hp := 20

var current_target: Node3D = null
var is_attacking := false

func _ready():
	print("Враг загружен!")
	find_target()

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
	if not is_instance_valid(current_target):
		is_attacking = false
		find_target()
		return

	if current_target.has_method("take_damage"):
		current_target.take_damage(attack_damage)

	await get_tree().create_timer(attack_interval).timeout
	attack_loop()

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
