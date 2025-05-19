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

		if result and result.collider.is_in_group("ground"):
			var world_pos = result.position
			var grid_pos = GridManager.world_to_grid(world_pos)

			if GridManager.is_cell_occupied(grid_pos):
				print("Клетка занята!")
				return

			if GameManager.spend_metal(3):  # Стоимость постройки
				var barracks = preload("res://scenes/Barracks.tscn").instantiate()
				get_tree().current_scene.add_child(barracks)
				barracks.global_transform.origin = GridManager.grid_to_world(grid_pos)
				GridManager.occupy_cell(grid_pos)
