extends CanvasLayer

@onready var next_round_btn := %"Next Round Button" as Button

signal next_round_requested

func _ready() -> void:
    next_round_btn.pressed.connect(func(): next_round_requested.emit())
