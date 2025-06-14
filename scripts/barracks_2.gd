# barracks_1.gd

extends Node3D

@export var hp := 175
@export var unit_count := 3
@export var spawn_scene := preload("res://scenes/humanoids/Unit.tscn") 

var is_placed := false

func _ready():
	pass


func place_barracks():
	is_placed = true
	add_to_group("targetable")
	add_to_group("barracks") 
	$Timer.wait_time = 20.0
	$Timer.start()
	print("Казарма активирована и начала спавн юнитов.")
	

func _on_timer_timeout():
	if not is_placed:
		return

	for i in unit_count:
		var unit = spawn_scene.instantiate()
		get_parent().add_child(unit)
		unit.global_transform.origin = global_transform.origin + Vector3(randf() * 3.0, 0.5, randf() * 3.0)
		SoundManager.play_2d(AudioLibrary.sfx_unit_spawn)

func take_damage(amount: int, _attacker: Node3D = null):
	if not is_inside_tree():
		return

	if not is_placed:
		print("Казарма ещё не активирована, но получила урон.")
	
	hp -= amount
	print("Казарма получила урон:", amount, " Осталось HP:", hp)
	if hp <= 0:
		print("Казарма уничтожена.")
		_on_destroyed()
		queue_free()
		GameManager.check_game_over()


func _on_destroyed():
	var grid_pos = GridManager.world_to_grid(global_transform.origin)
	GridManager.free_cell(grid_pos)
