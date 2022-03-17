extends GoapAction

class_name WanderAction


func get_id() -> String:
	return "WanderAction"

func get_cost(_blackboard) -> int:
	return 1


func get_effects() -> Dictionary:
	return {
		"wander": true
		}


func perform(actor : Entity, delta) -> bool:
	if	actor.wander_target == Vector2.ZERO:
		return false

	if actor.wander_target.distance_to(actor.position) > 20:
		actor.move_to(actor.position.direction_to(actor.wander_target), delta)

	return true

