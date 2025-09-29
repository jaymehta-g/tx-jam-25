extends Node2D

@export var min_speed: float = 5.0   # minimum degrees per second
@export var max_speed: float = 55.0  # maximum degrees per second

var sprite: Sprite2D 
@export var rotation_dir:int = [-1, 1].pick_random()

var current_speed: float = 0.0

func _ready() -> void:
	sprite = get_node_or_null("Sprite2D")
	# Give gear a random starting angle (0–360 degrees)
	if sprite:
		sprite.rotation_degrees = randf_range(0.0, 360.0)
	
	_set_random_rotation()

func _process(delta: float) -> void:
	if not sprite:
		return
	
	# Rotate sprite
	sprite.rotation_degrees += current_speed * delta

func _set_random_rotation() -> void:
	# Random direction: 1 = clockwise, -1 = counterclockwise
	#var direction: int
	#if randf_range(0, 1) < 0.5:
	#	direction = 1   # clockwise
	#else:
	#	direction = -1  # counterclockwise
	
	# Random speed within range
	var speed := randf_range(min_speed, max_speed)
	
	current_speed = speed * rotation_dir
