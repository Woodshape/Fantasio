#
# This script integrates the actor (NPC) with goap.
# In your implementation you could have this logic
# inside your NPC script.
#
# As good practice, I suggest leaving it isolated like
# this, so it makes re-use easy and it doesn't get tied
# to unrelated implementation details (movement, collisions, etc)
extends Node

class_name GoapAgent

var _goals : Array
var _current_goal : GoapGoal
var _current_action : GoapAction
var _current_plan : Array
var _current_plan_step = 0

var _beliefs : Dictionary

var _actor : Entity

var _action_planner :=  GoapActionPlanner.new()

var target : Vector2


#
# On every loop this script checks if the current goal is still
# the highest priority. if it's not, it requests the action planner a new plan
# for the new high priority goal.
#
func _process(delta):
	var goal = _get_best_goal()
	if _current_goal == null || goal != _current_goal:
		# You can set in the blackboard any relevant information you want to use
		# when calculating action costs and status. I'm not sure here is the best
		# place to leave it, but I kept here to keep things simple.
		var blackboard = {
			"position": _actor.position,
		}

		for b in _beliefs:
			blackboard[b] = _beliefs[b]

		for s in WorldState.get_states():
			blackboard[s] = WorldState.get_states()[s]
			

		_current_action = null
		_current_goal = goal
		_current_plan = _action_planner.get_plan(_current_goal, blackboard)
		_current_plan_step = 0
	else:
		_follow_plan(_current_plan, delta)


func setup(actor : Entity):
	_actor = actor
	_action_planner.set_agent(actor)


func set_goals(goals: Array):
	_goals = goals


func set_actions(actions: Array):
	if _action_planner == null:
		return

	_action_planner.set_actions(actions)


func get_belief(id : String, default = null):
	return _beliefs.get(id, default)


func set_belief(id : String, value):
	_beliefs[id] = value


func get_current_goal_name() -> String:
	if _current_goal != null:	
		return _current_goal.get_id()

	return ""


func get_current_action_name() -> String:
	if _current_action != null:	
		return _current_action.get_id()

	return ""
#
# Returns the highest priority goal available.
#
func _get_best_goal():
	var highest_priority

	for goal in _goals:
		if (
			goal.is_valid(self)
			&& (highest_priority == null || goal.priority(self) > highest_priority.priority(self))
		):
			highest_priority = goal

	return highest_priority


#
# Executes plan. This function is called on every game loop.
# "plan" is the current list of actions, and delta is the time since last loop.
#
# Every action exposes a function called perform, which will return true when
# the job is complete, so the agent can jump to the next action in the list.
#
func _follow_plan(plan, delta):
	if plan.size() == 0:
		return

	var action = plan[_current_plan_step]
	_current_action = action

	# Step through all items (i.e. action performances) of the plan
	# until there are no more actions to perform. Each action performace
	# has to be successful in order for the next one to perform.
	var is_step_complete = action.perform(_actor, delta)
	if is_step_complete && _current_plan_step < plan.size() - 1:
		_current_plan_step += 1
