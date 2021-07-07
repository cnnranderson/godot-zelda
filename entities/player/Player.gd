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
		direction = Direction.LEFT
	elif Input.is_action_pressed(Events.Actions.MoveRight):
		velocity.x = 1
		direction = Direction.RIGHT
	
	if Input.is_action_pressed(Events.Actions.MoveUp):
		velocity.y = -1
		if not is_attacking and (not $AnimatedSprite.playing or velocity.x == 0):
			direction = Direction.UP
	elif Input.is_action_pressed(Events.Actions.MoveDown):
		velocity.y = 1
		if not is_attacking and (not $AnimatedSprite.playing or velocity.x == 0):
			direction = Direction.DOWN
	velocity = velocity.normalized() * speed
	
	if Input.is_action_pressed(Events.Actions.Attack) and not is_attacking:
		weapon.attack(direction)
		attack_time = 10
		is_attacking = true
		weapon.visible = true
		$AnimatedSprite.frame = 0
	if Input.is_action_just_released(Events.Actions.Attack) and is_attacking:
		is_attacking = false
	
	if is_attacking or attack_time != 0:
		match direction:
			Direction.DOWN: $AnimatedSprite.play("attack_down")
			Direction.UP: $AnimatedSprite.play("attack_up")
			Direction.LEFT: $AnimatedSprite.play("attack_left")
			Direction.RIGHT: $AnimatedSprite.play("attack_right")
	elif velocity != Vector2.ZERO:
		match direction:
			Direction.DOWN: $AnimatedSprite.play("walk_down")
			Direction.UP: $AnimatedSprite.play("walk_up")
			Direction.LEFT: $AnimatedSprite.play("walk_left")
			Direction.RIGHT: $AnimatedSprite.play("walk_right")

func _physics_process(delta):
	_check_input()
	$LookAheadPivot.position = velocity / 3
	
	if is_attacking or attack_time != 0:
		velocity = Vector2.ZERO
	elif not is_attacking and attack_time == 0:
		weapon.visible = false
		match direction:
			Direction.DOWN: $AnimatedSprite.play("walk_down")
			Direction.UP: $AnimatedSprite.play("walk_up")
			Direction.LEFT: $AnimatedSprite.play("walk_left")
			Direction.RIGHT: $AnimatedSprite.play("walk_right")
	if attack_time > 0:
		attack_time = max(attack_time - (weapon.attack_speed * delta), 0)
	
	$AnimatedSprite.playing = (velocity != Vector2.ZERO or attack_time != 0)
	velocity = move_and_slide(velocity)
