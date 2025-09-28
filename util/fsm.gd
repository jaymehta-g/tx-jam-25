class_name FSM
extends Node

@export var init_state: State
@export var actor: Node

var curr_state: State

func _initialize_state(s: State):
	s.fsm = self
	s.actor = actor

func _ready() -> void:
	if not actor:
		actor = get_parent()
	_initialize_state(init_state)
	curr_state = init_state
	init_state._state_enter()

func switch_state(new_state: State) -> void:
	_initialize_state(new_state)
	curr_state._state_exit()
	curr_state = new_state
	curr_state._state_enter()

func _process(delta: float) -> void:
	curr_state._state_process(delta)

func _physics_process(delta: float) -> void:
	curr_state._state_physics_process(delta)
