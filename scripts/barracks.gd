# barracks.gd

extends Area3D

@export var hp := 100
@export var unit_count := 1
@export var spawn_scene:= preload("res://scenes/humanoids/Unit.tscn")  # сюда потом префаб юнита

func _ready():
	$Timer.start()

func _on_timer_timeout():
	for i in unit_count:
		var unit = spawn_scene.instantiate()
		get_parent().add_child(unit)
		unit.global_transform.origin = global_transform.origin + Vector3(randf()*2.0, 1, randf()*2.0)

func _on_destroyed():  # вызови при разрушении или удалении
	var grid_pos = GridManager.world_to_grid(global_transform.origin)
	GridManager.free_cell(grid_pos)
