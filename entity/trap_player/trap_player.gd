extends Node2D

@export var traps: Array[TrapInfo]
const HAZARD = preload("uid://d1mn45ydc6cma")

@onready var audio_error:AudioStreamPlayer2D = $AudioError
@onready var audio_confirm:AudioStreamPlayer2D = $AudioConfirm

var is_holding_item := false
var held_item: Node2D

@onready var click_cooldown: Timer = $"Click Cooldown"

func _item_picked(trap: TrapInfo):
	if Game.instance.trapping_player.time_left <= trap.cost:
		audio_error.play()
		return
	Game.instance.trapping_player.time_left -= trap.cost
	Game.instance.item_shop.score_label.text = "%ss" % Game.instance.trapping_player.time_left 

	var n := trap.scene.instantiate() as Node2D
	add_child(n)
	held_item = n
	is_holding_item = true
	audio_confirm.play()
	click_cooldown.start() # avoid accidentally immediately placing on click

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.trap_picked.connect(_item_picked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = get_viewport().get_mouse_position() + get_viewport().get_camera_2d().position
	if is_holding_item and Input.is_action_just_pressed("click") and click_cooldown.is_stopped():
		is_holding_item = false
		# HACK
		remove_child(held_item)
		get_parent().add_child(held_item)
		held_item.position = position
		held_item.activate()
		held_item = null
		
		SignalBus.trap_placed.emit()
