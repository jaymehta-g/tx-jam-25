extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_node := Game.instance.running_player.node
	var camera_threshold := 200.0
	var desired_camera_y := player_node.position.y-700.0 as float
	var position_diff: float = desired_camera_y - position.y
	if absf(position_diff) > camera_threshold:
		position.y += (absf(position_diff) - camera_threshold) * 10.0 * delta * sign(position_diff)
		position.y = clamp(position.y, -3240, 0)
