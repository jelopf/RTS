extends CharacterBody3D

@export var speed := 1.0
@export var attack_range := 1.5
@export var attack_damage := 4
@export var attack_interval := 3.0  

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
	var direction = (target.global_transform.origin - global_transform.origin).normalized()
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

	current_target.take_damage(attack_damage)
	# print("Враг атакует:", current_target.name)

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
