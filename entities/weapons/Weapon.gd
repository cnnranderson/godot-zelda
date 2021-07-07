extends Node2D
class_name Weapon

enum Direction {LEFT, UP, RIGHT, DOWN}

var attack_speed = 30

var end_pos = Vector2.ZERO
var end_rot = 0

func attack(dir: int, position):
	# Setup position
	match dir:
		Direction.LEFT:
			$Pivot.position = Vector2(-2, 0)
			end_pos = Vector2(-5, 4)
		Direction.RIGHT:
			$Pivot.position = Vector2(0, 5)
			end_pos = Vector2(5, 2)
		Direction.UP:
			$Pivot.position = Vector2(5, 3)
			end_pos = Vector2(-3, -5)
		Direction.DOWN:
			$Pivot.position = Vector2(-3, 5)
			end_pos = Vector2(3, 5)
	
	# Setup rotation
	$Pivot.rotation = deg2rad(dir * 90)
	end_rot = deg2rad((dir - 1) * 90)
	
	# Make visible
	visible = true

func _physics_process(delta):
	$Pivot.rotation = lerp($Pivot.rotation, end_rot, .5)
	$Pivot.position = lerp($Pivot.position, end_pos, .5)
