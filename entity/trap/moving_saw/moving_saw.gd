extends BaseTrap

var activated_time := 0.0

@export var nodes_to_move: Array[Node2D]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_activated:
		activated_time += delta
		for n in nodes_to_move:
			n.position.x = sin(activated_time/0.5) * 200
		$Sprite2D.rotation = activated_time*30.0
	super._process(delta)
