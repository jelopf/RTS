extends Label

func _process(_delta):
	if GameManager.ghost_building:
		text = "Выберите место на карте\nНажмите [Esc], чтобы отменить"
	else:
		text = ""
