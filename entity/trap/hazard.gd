class_name BaseTrap
extends Area2D

@onready var label: Label = $Label
@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var health := 3
var is_activated := false

# walls can set this false
var deadly := true

signal activated

func activate():
	timer.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_activate_timer_ready)
	body_entered.connect(_collision)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer.time_left > 0:
		label.text = "%0.2f" % timer.time_left 

func _activate_timer_ready():
	label.queue_free()
	is_activated = true
	activated.emit()
	sprite_2d.modulate.a = 1.0
	collision_shape_2d.disabled = false

func _collision(b: Node2D):
	if b is Player and deadly:
		print_debug("you died lol")
		SignalBus.player_hurt.emit()
