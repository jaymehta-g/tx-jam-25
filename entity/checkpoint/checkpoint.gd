extends Area2D

func _ready() -> void:
    body_entered.connect(_on_body)

func _on_body(n: Node2D):
    if not n.is_in_group(Groups.PLAYER_RUNNING): return
    SignalBus.checkpoint_hit.emit(global_position)