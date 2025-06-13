# SaveManager.gd

extends Node

const SAVE_PATH = "user://save_data.cfg"

func is_first_time() -> bool:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	return err != OK or not config.has_section_key("Progress", "first_time")

func mark_tutorial_seen():
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("Progress", "first_time", false)
	config.save(SAVE_PATH)

func unlock_level(level_index: int):
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("Progress", "unlocked_level", level_index)
	config.save(SAVE_PATH)

func get_unlocked_level() -> int:
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	return config.get_value("Progress", "unlocked_level", 0)

# временно
func reset_save():
	var config = ConfigFile.new()
	config.clear()
	config.save(SAVE_PATH)
