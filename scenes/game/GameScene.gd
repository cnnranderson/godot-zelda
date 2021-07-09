extends Node2D

var camera = {
	'target': Vector2.ZERO,
	'zoom': 0.5
}

func _ready():
	pass

func _physics_process(delta):
	camera.target = $Player.position + $Player/LookAheadPivot.position
	_update_camera(delta)

func _update_camera(delta):
	$Camera.position = camera.target
	$Camera.zoom = Vector2.ONE * camera.zoom
