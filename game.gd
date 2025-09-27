extends Node2D

const HAZARD = preload("uid://d1mn45ydc6cma")

var traps_left := 4
@onready var timer: Timer = $Timer
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(func():
		traps_left += 1
		traps_left = min(traps_left, 5)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "Traps Left: %s" % traps_left
	if Input.is_action_just_pressed("click") and traps_left > 0:
		traps_left -= 1
		var pos := get_viewport().get_mouse_position()
		var n := HAZARD.instantiate()
		n.position = pos
		add_child(n)
