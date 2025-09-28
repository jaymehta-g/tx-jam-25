@abstract
class_name State
extends Node

var fsm: FSM
var actor: Node

func _state_enter() -> void:
    pass

func _state_exit() -> void:
    pass

func _state_process(delta: float) -> void:
    pass

func _state_physics_process(delta: float) -> void:
    pass