# TutorialPopup.gd

extends Control

@onready var label = $Panel/Label

var tutorial_texts := [
	"Юниты могут добывать ресурсы и драться.",
	"Управляются кликом мыши по руде/врагу.",
	"Если не давать приказ — нападают на ближайшего врага.",
	"Казармы строятся за руду и спавнят юнитов раз в 20 секунд.",
	"Чтобы открыть магазин, нажмите М.",
	"Руда находится на поле в ограниченном количестве и восстанавливается со временем."
]

var current_index := 0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS 
	label.text = tutorial_texts[current_index]
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		current_index += 1
		if current_index < tutorial_texts.size():
			label.text = tutorial_texts[current_index]
		else:
			start_level()

func start_level():
	GameManager.set_game_paused(false)

	var level = get_tree().current_scene
	if level.has_method("start_waves"):
		level.start_waves()

	SaveManager.mark_tutorial_seen()
	queue_free()

	
