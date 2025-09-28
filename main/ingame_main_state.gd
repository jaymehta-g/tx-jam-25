extends State

@export var game_scene: PackedScene

func _state_enter() -> void:
	actor.add_child(game_scene.instantiate())
