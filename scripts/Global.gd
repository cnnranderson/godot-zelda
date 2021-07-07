extends Node

enum Scenes { START_MENU, GAME }

const SceneMap = {
	Scenes.START_MENU: "res://scenes/start/StartScene.tscn",
	Scenes.GAME: "res://scenes/game/GameScene.tscn"
}

var main : Main = null
var debug = true

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(_delta):
	if debug:
		if Input.is_action_pressed("debug_quit"):
			get_tree().quit()
