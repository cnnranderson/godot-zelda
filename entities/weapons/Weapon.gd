extends Node2D
class_name Weapon

enum Direction {LEFT, UP, RIGHT, DOWN}

var attack_speed = 30

var end_pos = Vector2.ZERO
var end_rot = 0
var rot_elapsed = 0.0

func attack(dir: int):
	# Setup position
	match dir:
		Direction.LEFT:
			$Pivot.position = Vector2(-1, -8)
			end_pos = Vector2(-6, 4)
		Direction.RIGHT:
			$Pivot.position = Vector2(1, -8)
			end_pos = Vector2(6, 4)
		Direction.UP:
			$Pivot.position = Vector2(12, 5)
			end_pos = Vector2(-3, -5)
		Direction.DOWN:
			$Pivot.position = Vector2(-12, -5)
			end_pos = Vector2(3, 6)
	
	# Setup rotation (Special case for right swing)
	if dir == Direction.RIGHT:
		$Pivot.rotation = deg2rad(Direction.LEFT * 90)
		end_rot = deg2rad((Direction.LEFT + 1) * 90)
	else:
		$Pivot.rotation = deg2rad(dir * 90)
		end_rot = deg2rad((dir - 1) * 90)
	rot_elapsed = 0.0

func _physics_process(delta):
	$Pivot.rotation = lerp_angle($Pivot.rotation, end_rot, rot_elapsed)
	$Pivot.position = lerp($Pivot.position, end_pos, .5)
	if rot_elapsed <= 1:
		rot_elapsed += delta * attack_speed / 3
	
