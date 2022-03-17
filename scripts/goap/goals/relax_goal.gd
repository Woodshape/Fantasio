extends GoapGoal

class_name RelaxGoal

func get_id() -> String:
	return "RelaxGoal"

# relax will always be available
func is_valid(_agent) -> bool:
	return true


# relax has lower priority compared to other goals
func priority(_agent) -> int:
	return 0
