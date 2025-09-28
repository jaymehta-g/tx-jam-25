class_name Game
extends Node2D
static var instance: Game



const HAZARD = preload("uid://d1mn45ydc6cma")
const max_rooms = 3
# width of shop is 300 pixels
const stage_y_size = 1080

@onready var stage0:PackedScene = preload("res://main/stages/stage0.tscn")
@onready var stage1:PackedScene = preload("res://main/stages/stage1.tscn")
@onready var stage2:PackedScene = preload("res://main/stages/stage2.tscn")
@onready var total_stages:Array = [stage0, stage1, stage2]

var players: Array[PlayerInfo] = [preload("uid://cxg4y4vhfhqlb"), preload("uid://8rh52pobuejj")]

var running_player := players[0]
var trapping_player = players[1]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(not instance)
	instance = self
	# hacky?
	tree_exiting.connect(func(): instance = null)
	
	for x in players: x.time_left = 5*60
	running_player.node = $Player
	trapping_player.node = null
	
	_choose_scenes()

func _process(delta: float) -> void:
	running_player.time_left -= delta


func _choose_scenes() -> void:
	# choose 3 rooms at a random order and sequence
	var stages = total_stages.duplicate()
	stages.shuffle()
	stages = stages.slice(0, 3, 1, true)
	# need to add floor to 1st stage always - bectter way to do this ? 
	var first_scene = stages.pop_at(0)
	var first_room = first_scene.instantiate()
	var pos = first_room.global_position.y
	first_room.add_to_group("Rooms")
	add_child(first_room)
	
	#var pos := 0.0
	# add the remaining 
	for stage in stages:
		var room = stage.instantiate()
		pos -= stage_y_size
		room.global_position.y = pos
		room.add_to_group("Rooms")
		add_child(room)
