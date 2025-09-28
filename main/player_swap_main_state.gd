extends State

@export var game_state: State
@export var ui_scene: PackedScene
var ui_node: Node

func _state_enter() -> void:
    ui_node = ui_scene.instantiate()
    (ui_node.next_round_requested as Signal) \
        .connect(_on_next_button_press)
    actor.add_child(ui_node)

func _on_next_button_press():
    fsm.switch_state(game_state)

func _state_exit() -> void:
    ui_node.queue_free()