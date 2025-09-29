extends CanvasLayer

@export var shop_displays: Array[ItemDisplaySpace]

@onready var p1score := %Player1Score as Label
@onready var p2score := %Player2Score as Label

signal trap_picked(type, cost)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	p1score.text = "Player 1:\n%0.1f s" % Globals.players[0].time_left
	p2score.text = "Player 2:\n%0.1f s" % Globals.players[1].time_left
