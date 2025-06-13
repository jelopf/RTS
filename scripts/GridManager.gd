# GridManager.gd

extends Node

const CELL_SIZE = 5.0  

var occupied_cells := {}

func world_to_grid(position: Vector3) -> Vector2i:
	return Vector2i(
		int(round(position.x / CELL_SIZE)),
		int(round(position.z / CELL_SIZE))
	)

func grid_to_world(grid_pos: Vector2i) -> Vector3:
	return Vector3(
		grid_pos.x * CELL_SIZE,
		0.0,
		grid_pos.y * CELL_SIZE
	)

func is_cell_occupied(grid_pos: Vector2i) -> bool:
	return occupied_cells.has(grid_pos)

func occupy_cell(grid_pos: Vector2i):
	occupied_cells[grid_pos] = true

func free_cell(grid_pos: Vector2i):
	occupied_cells.erase(grid_pos)
