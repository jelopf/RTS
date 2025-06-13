# story_screen.gd

extends Control

var story_texts := [
	"Пару недель назад наш корабль прибыл на неведомую планету, и мы приступили к её изучению.

Наши исследователи нашли огромное количество ресурсов на этой планете!",

	"Мы решили что она станет нашим новым домом.",
	
	"Однако мы наткнулись на живых существ… ",
	
	"Несмотря на примитивный внешний вид они подают признаки разума.

Похоже на то, что у них есть свой язык и какие-то формы организации.",

	"И эта находка расколола нас на два лагеря.

Одни хотят уничтожить эти организмы, другие же за мирное существование всем вместе.",

	"Я остался в лагере мирных, однако вчерашние друзья нападают на нас, а нам приходится защищаться…",
	
	"Надеюсь у нас получится мирно существовать на этой планете.

Кажется, местные разумные существа называют ее “Земля”."
]

@onready var story_label = $Panel/Label
var current_index := 0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	story_label.text = story_texts[current_index]
	set_process_input(true)
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP  

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		current_index += 1
		if current_index < story_texts.size():
			story_label.text = story_texts[current_index]
		else:
			go_to_tutorial()

func go_to_tutorial():
	var tutorial = preload("res://scenes/UI/TutorialPopup.tscn").instantiate()
	get_tree().current_scene.add_child(tutorial)
	GameManager.set_game_paused(true)
	queue_free()
