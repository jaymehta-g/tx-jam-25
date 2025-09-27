extends Node2D

const HAZARD = preload("uid://d1mn45ydc6cma")
const max_rooms = 3


#@onready var timer: Timer = $Timer
#@onready var label: Label = $Label

@onready var stage0:PackedScene = preload("res://main/stages/stage0.tscn")
@onready var stage1:PackedScene = preload("res://main/stages/stage0.tscn")
@onready var stage2:PackedScene = preload("res://main/stages/stage0.tscn")

@onready var stages:Array = [stage0, stage1, stage2]


# prolly don't need 
@onready var current_rooms: Array:
	get:
		return get_tree().get_nodes_in_group("Rooms")

var traps_left := 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#autoload scenes
	_choose_scenes()


	# timer.timeout.connect(func():
	# 	traps_left += 1
	# 	traps_left = min(traps_left, 5)
	# )

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass
	#label.text = "Traps Left: %s" % traps_left
	#if Input.is_action_just_pressed("click") and traps_left > 0:
		#traps_left -= 1
		#var pos := get_viewport().get_mouse_position()
		#var n := HAZARD.instantiate()
		#n.position = pos
		#add_child(n)

func _choose_scenes() -> void:
	# choose 3 rooms at a random order and sequence
	#stages.duplicate().shuffle().slice(0, 2)
	pass

	#for stage in stages: 
		#stage 

func _on_stage_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print('next stage up')

func _on_trap_timer_timeout():
	if traps_left < 5:
		traps_left += 1
	
	
