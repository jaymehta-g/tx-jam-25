extends CanvasLayer

@export var shop_displays: Array[ItemDisplaySpace]

@onready var runner_score = %Player1Score
@onready var score_label = %Player2Score

signal trap_picked(type, cost)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
