extends Camera3D

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var from = project_ray_origin(event.position)
		var to = from + project_ray_normal(event.position) * 1000
		var space_state = get_world_3d().direct_space_state
		var ray_params = PhysicsRayQueryParameters3D.new()
		ray_params.from = from
		ray_params.to = to
		ray_params.collide_with_areas = true
		ray_params.collide_with_bodies = true
		var result = space_state.intersect_ray(ray_params)

		if result:
			var clicked = result.collider
			# Проверим: входит ли объект в нужную группу, прежде чем звать on_clicked
			if clicked and clicked.is_in_group("resource") and clicked.has_method("on_clicked"):
				clicked.call("on_clicked")
			print("Ты кликнул на:", result.collider.name)
			if result.collider and result.collider.is_in_group("ground"):
				if GameManager.spend_metal(3):  # Стоимость постройки
					var barracks = preload("res://scenes/Barracks.tscn").instantiate()
					get_tree().current_scene.add_child(barracks)
					barracks.global_transform.origin = result.position

		
		
