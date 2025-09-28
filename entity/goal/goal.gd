extends Area2D

func _ready() -> void:
    body_entered.connect(_body_enter)

func _body_enter(n: Node2D):
    if not n.is_in_group(Groups.PLAYER_RUNNING): return
    var _p := n as Player
    SignalBus.goal_reached.emit()
