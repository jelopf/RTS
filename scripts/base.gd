extends Area3D

@export var max_health := 100
var current_health := max_health

func _ready():
	print("База активна. Здоровье:", current_health)

func take_damage(amount):
	current_health -= amount
	print("Базе нанесён урон:", amount, "Осталось здоровья:", current_health)
	if current_health <= 0:
		die()

func die():
	print("База разрушена!")
	queue_free()  # удалим объект
