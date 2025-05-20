extends Area3D

@export var hp := 250
@export var unit_count := 5
@export var spawn_scene := preload("res://scenes/Unit.tscn")  # сюда потом префаб юнита

var is_placed := false  # чтобы следить, построена ли казарма

func _ready():
	# Пока ничего не запускаем, ждём place_barracks()
	pass

func place_barracks():
	is_placed = true
	add_to_group("targetable")
	$Timer.wait_time = 20.0
	$Timer.start()
	print("Казарма активирована и начала спавн юнитов.")

func _on_timer_timeout():
	if not is_placed:
		return  # Не спавним, если казарма ещё не построена

	for i in unit_count:
		var unit = spawn_scene.instantiate()
		get_parent().add_child(unit)
		unit.global_transform.origin = global_transform.origin + Vector3(randf() * 2.0, 1, randf() * 2.0)

func take_damage(amount: int, _attacker: Node3D = null):
	if not is_placed:
		return  # Призраки не получают урон

	hp -= amount
	print("Казарма получила урон:", amount, " Осталось HP:", hp)
	if hp <= 0:
		print("Казарма уничтожена.")
		_on_destroyed()
		queue_free()

func _on_destroyed():
	var grid_pos = GridManager.world_to_grid(global_transform.origin)
	GridManager.free_cell(grid_pos)
