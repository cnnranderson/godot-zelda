extends Node2D

func _ready():
	pass

func _process(delta):
	_update_camera(delta)

func _update_camera(delta):
	var look_ahead = $Player.position + $Player.velocity / 2
	$Camera.position = lerp($Camera.position, look_ahead, 0.05)
