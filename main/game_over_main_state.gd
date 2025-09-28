extends State

@export var game_over_scene: PackedScene
var ui_node: Node

func _state_enter() -> void:
    ui_node = game_over_scene.instantiate()
    actor.add_child(ui_node)