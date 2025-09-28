extends State

@export var swap_state: State
@export var game_over_state: State
@export var game_scene: PackedScene
var game_node: Game

func _state_enter() -> void:
	game_node = game_scene.instantiate()
	actor.add_child(game_node)
	SignalBus.ready_to_end_round.connect(func():
		fsm.switch_state(swap_state)
		)
	game_node.player_out_of_time.connect(func(_losing_player):
		fsm.switch_state(game_over_state)
		)

	

func _state_exit() -> void:
	game_node.queue_free()
