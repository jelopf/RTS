extends Area3D

@export var hp := 100
@export var unit_count := 1
@export var spawn_scene:= preload("res://scenes/Unit.tscn")  # сюда потом префаб юнита

func _ready():
	$Timer.start()

func _on_timer_timeout():
	for i in unit_count:
		var unit = spawn_scene.instantiate()
		get_parent().add_child(unit)
		unit.global_transform.origin = global_transform.origin + Vector3(randf()*2.0, 1, randf()*2.0)
