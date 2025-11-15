extends Node
class_name FSM

signal on_state_change(String)

var states : Dictionary[String, State] = {}
var current_state : State
var current_state_key : String

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.fsm = self
			states[child.name.to_lower()] = child
			
		else:
			child.queue_free()
			push_warning("State machine contains a none state object")
	if states.is_empty():
		queue_free()
	else:
		change_state(states.keys()[0])

func physics_update(delta:float)->void:
	current_state.physics_update(delta)

func update(delta:float)->void:
	current_state.update(delta)

func change_state(state_name : String)->void:
	if states.has(state_name):
		if current_state_key == state_name:
			return
		if current_state:
			current_state.exit()
		current_state = states[state_name]
		on_state_change.emit(state_name)
		current_state.enter()
		current_state_key = state_name
