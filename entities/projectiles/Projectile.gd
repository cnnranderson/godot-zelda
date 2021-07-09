extends KinematicBody2D
class_name Projectile

export var speed = 180

var velocity = Vector2.ZERO

func _physics_process(delta):
	move_and_slide(velocity * speed)

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func _on_Hurtbox_area_shape_entered(area_id, area, area_shape, local_shape):
	if area.name == "Hitbox":
		queue_free()
