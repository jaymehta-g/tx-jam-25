extends State

@export var ui_scene: PackedScene
var ui_node: Node

func _state_enter() -> void:
    ui_node = ui_scene.instantiate()
    actor.add_child(ui_node)

func _state_exit() -> void:
    ui_node.queue_free()