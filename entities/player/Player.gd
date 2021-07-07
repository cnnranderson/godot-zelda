extends KinematicBody2D

enum Dir {LEFT, RIGHT, UP, DOWN}

var velocity = Vector2.ZERO
var speed = 60
var curr_dir = Dir.DOWN
var is_moving = false

func _ready():
	pass

func _check_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed(Events.Actions.MoveLeft):
		velocity.x = -1
		$AnimatedSprite.play("walk_left")
	if Input.is_action_pressed(Events.Actions.MoveRight):
		velocity.x = 1
		$AnimatedSprite.play("walk_right")
	
	if Input.is_action_pressed(Events.Actions.MoveUp):
		velocity.y = -1
		$AnimatedSprite.play("walk_up")
	if Input.is_action_pressed(Events.Actions.MoveDown):
		velocity.y = 1
		$AnimatedSprite.play("walk_down")
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	_check_input()
	velocity = move_and_slide(velocity)
	$AnimatedSprite.playing = (velocity != Vector2.ZERO)
