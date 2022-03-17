extends Entity

class_name Character

var wander_target : Vector2

@onready var _wander_timer := $WanderTimer


# Called when the node enters the scene tree for the first time.
func _ready():	
	var goals = [WanderGoal.new()]
	var actions = [WanderAction.new()]

	# Setup agent with above goals and actions
	_agent = GoapAgent.new()
	_agent.setup(self)
	_agent.set_goals(goals)
	_agent.set_actions(actions)
	
	# Lastly, I add the agent to the npc scene.
	add_child(_agent)


func _on_wander_timer_timeout():
	randomize()
	_wander_timer.wait_time = randi() % 10 + 3
	wander_target = _pick_random_position()
