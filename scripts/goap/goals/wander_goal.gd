extends GoapGoal

class_name WanderGoal


func get_id() -> String:
	return "WanderGoal"


func is_valid(_agent) -> bool:
	return true


func priority(_agent) -> int:
	return 0


func get_desired_state() -> Dictionary:
	return {
		"wander": true
		}
