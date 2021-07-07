extends KinematicBody2D

const Sword = preload("res://entities/weapons/sword/Sword.tscn")

enum Direction {LEFT, UP, RIGHT, DOWN}

var velocity = Vector2.ZERO
var speed = 60
var is_attacking = false
var direction = Direction.DOWN
var weapon : Weapon
var attack_time = 0

func _ready():
	_init_equipment()

func _init_equipment():
	weapon = Sword.instance()
	weapon.visible = false
	$Weapon.add_child(weapon)

func _check_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed(Events.Actions.MoveLeft):
		velocity.x = -1
		$AnimatedSprite.play("walk_left")
		direction = Direction.LEFT
	elif Input.is_action_pressed(Events.Actions.MoveRight):
		velocity.x = 1
		$AnimatedSprite.play("walk_right")
		direction = Direction.RIGHT
	
	if Input.is_action_pressed(Events.Actions.MoveUp):
		velocity.y = -1
		if not $AnimatedSprite.playing or velocity.x == 0:
			direction = Direction.UP
			$AnimatedSprite.play("walk_up")
	elif Input.is_action_pressed(Events.Actions.MoveDown):
		velocity.y = 1
		if not $AnimatedSprite.playing or velocity.x == 0:
			direction = Direction.DOWN
			$AnimatedSprite.play("walk_down")
	velocity = velocity.normalized() * speed
	
	if Input.is_action_pressed(Events.Actions.Attack) and not is_attacking:
		weapon.attack(direction, position)
		attack_time = 10
		is_attacking = true
	if Input.is_action_just_released(Events.Actions.Attack) and is_attacking:
		is_attacking = false

func _physics_process(delta):
	_check_input()
	$LookAheadPivot.position = velocity / 3
	
	if is_attacking or attack_time != 0:
		velocity = Vector2.ZERO
	elif not is_attacking and attack_time == 0:
		weapon.visible = false
	if attack_time > 0:
		attack_time = max(attack_time - (weapon.attack_speed * delta), 0)
	
	$AnimatedSprite.playing = (velocity != Vector2.ZERO)
	velocity = move_and_slide(velocity)
