extends CanvasLayer

@onready var next_round_btn := %"Next Round Button" as Button

@export var p1_label: Label
@export var p2_label: Label
@export var next_player: Label

signal next_round_requested

func _ready() -> void:
	p1_label.text = "Player 1 has %0.2f seconds"
	p1_label.text = p1_label.text % Globals.players[0].time_left
	p2_label.text = "Player 2 has %0.2f seconds"
	p2_label.text = p2_label.text % Globals.players[1].time_left
	next_player.text = "Next round:\nPlayer %s is the runner!" % \
		("1" if Globals.round_number % 2 == 0 else "2")
	next_round_btn.pressed.connect(func(): next_round_requested.emit())
