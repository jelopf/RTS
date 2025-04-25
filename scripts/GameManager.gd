extends Node

var metal := 10

func add_metal(amount: int):
	metal += amount
	print("Металл теперь: ", metal)

func spend_metal(amount: int) -> bool:
	if metal >= amount:
		metal -= amount
		print("Потрачено! Осталось металла: ", metal)
		return true
	print("Недостаточно металла!")
	return false
