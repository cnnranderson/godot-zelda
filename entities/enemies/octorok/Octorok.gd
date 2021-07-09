extends Enemy

const Projectile = preload("res://entities/projectiles/Projectile.tscn")

enum States { IDLE, WALK, ATTACK }
enum Direction { LEFT, UP, RIGHT, DOWN }

var speed = 30
var walk_timer = 1
var attack_timer = 2
var bullet = null
var velocity = Vector2.ZERO
var direction = Direction.DOWN

func _ready():
	add_state(States.IDLE)
	add_state(States.WALK)
	add_state(States.ATTACK)
	set_state(States.IDLE)

func _physics_process(delta):
	act(delta)
	velocity = $Body.move_and_slide(velocity)

func _state_logic(delta):
	if attack_timer > 0 and state == States.IDLE:
		attack_timer -= delta
	if walk_timer > 0 and state != States.ATTACK:
		walk_timer -= delta
	match state:
		States.IDLE: velocity = Vector2.ZERO
		States.WALK: 
			match direction:
				Direction.DOWN: velocity = Vector2.DOWN * speed
				Direction.UP: velocity = Vector2.UP * speed
				Direction.LEFT: velocity = Vector2.LEFT * speed
				Direction.RIGHT: velocity = Vector2.RIGHT * speed
		States.ATTACK: velocity = Vector2.ZERO

func _get_transition(delta):
	match state:
		States.IDLE:
			if attack_timer <= 0:
				return States.ATTACK
			if walk_timer < 0:
				return States.WALK
		States.WALK:
			if walk_timer < 0:
				return States.IDLE
		States.ATTACK:
			if not is_instance_valid(bullet):
				return States.IDLE
		_: return States.IDLE

func _enter_state(new_state, old_state):
	print("Entering new state: %s" % new_state)
	state = new_state
	match new_state:
		States.IDLE:
			walk_timer = 1
			$Body/Sprite.playing = false
		States.WALK:
			walk_timer = 2
			direction = randi() % 4
			$Body/Sprite.playing = true
			match direction:
				Direction.DOWN: $Body/Sprite.play("walk_down")
				Direction.UP: $Body/Sprite.play("walk_up")
				Direction.LEFT: $Body/Sprite.play("walk_left")
				Direction.RIGHT: $Body/Sprite.play("walk_right")
		States.ATTACK:
			$Body/Sprite.playing = false
			walk_timer = 1
			attack_timer = randi() % 10 + 5
			attack()

func _exit_state(old_state, new_state):
	pass

func attack():
	if not is_instance_valid(bullet):
		bullet = Projectile.instance()
		var position = $Body.position
		match direction:
			Direction.DOWN:
				bullet.velocity = Vector2.DOWN
				bullet.position = Vector2(position.x, position.y + 8)
			Direction.UP:
				bullet.velocity = Vector2.UP
				bullet.position = Vector2(position.x, position.y - 8)
			Direction.LEFT:
				bullet.velocity = Vector2.LEFT
				bullet.position = Vector2(position.x - 8, position.y)
			Direction.RIGHT:
				bullet.velocity = Vector2.RIGHT
				bullet.position = Vector2(position.x + 8, position.y)
		add_child(bullet)
