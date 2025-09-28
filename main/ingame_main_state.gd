extends State

@export var swap_state: State
@export var game_scene: PackedScene
var game_node: Node

func _state_enter() -> void:
	game_node = game_scene.instantiate()
	actor.add_child(game_node)
	SignalBus.goal_reached.connect(func():
		fsm.switch_state(swap_state)
		)

func _state_exit() -> void:
	game_node.queue_free()
