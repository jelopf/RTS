extends Label

func _process(_delta):
	if GameManager.ghost_building:
		self.visible = true
	else:
		self.visible = false
