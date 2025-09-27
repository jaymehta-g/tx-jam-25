extends Area2D

signal attack_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(queue_free)
	area_entered.connect(_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _area_entered(n: Node2D):
	if n.is_in_group("Hazard"):
		n.health -= 1
		if n.health <= 0:
			n.queue_free()
		if is_equal_approx(rotation_degrees, 90):
			attack_hit.emit()
