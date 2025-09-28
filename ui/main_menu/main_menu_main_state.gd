extends State

@export var game_state: State
@export var menu_scene: PackedScene

var menu_node: Node

func _state_enter() -> void:
	menu_node = menu_scene.instantiate()
	actor.add_child.call_deferred(menu_node)
	(menu_node.start as Signal).connect(func():
		fsm.switch_state(game_state)
	)

func _state_exit() -> void:
	menu_node.queue_free()
