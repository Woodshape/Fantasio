extends CharacterBody2D

class_name Entity

@export var move_speed := 100

var _agent : GoapAgent

var is_moving := false
var is_attacking := false


func move_to(direction : Vector2, delta):
	is_moving = true
	is_attacking = false
	#$body.play("run")
	if direction.x > 0:
		turn_right()
	else:
		turn_left()

	var velo = direction * delta * move_speed
	# warning-ignore:return_value_discarded
	move_and_collide(velo)


func turn_right():
	if not $Body.flip_h:
		return

	$Body.flip_h = false


func turn_left():
	if $Body.flip_h:
		return

	$Body.flip_h = true


func _pick_random_position() -> Vector2:
	randomize()
	return Vector2(randi() % 445 + 5, randi() % 245 + 5)
