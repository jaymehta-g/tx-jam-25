extends CanvasLayer

@export var label: Label

func _ready() -> void:
	var p1win := Globals.players[1].time_left < 0.01
	var pname := "1" if p1win else "2"
	label.text = "Player %s Wins!" % pname
