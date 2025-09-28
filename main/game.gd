class_name Game
extends Node2D
static var instance: Game:
	get:
		return Globals.game_node



const HAZARD = preload("uid://d1mn45ydc6cma")
const max_rooms = 3
# width of shop is 300 pixels
const stage_y_size = 1080

@onready var stage0:PackedScene = preload("res://main/stages/stage0.tscn")
@onready var stage1:PackedScene = preload("res://main/stages/stage1.tscn")
@onready var stage2:PackedScene = preload("res://main/stages/stage2.tscn")
@onready var total_stages:Array = [stage0, stage1, stage2]

var players: Array[PlayerInfo]:
	get:
		return Globals.players

var running_player: PlayerInfo
var trapping_player: PlayerInfo

var should_count_down_timer := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.game_node = self
	# hacky?
	tree_exiting.connect(func(): Globals.game_node = null)
	
	# Initialize if we should
	if Globals.should_initialize_player_stats:
		for x in players: x.time_left = 5*60
		Globals.round_number = 0
		Globals.should_initialize_player_stats = false

	if Globals.round_number % 2 == 0:
		running_player = players[0]
		trapping_player = players[1]
	else:
		running_player = players[1]
		trapping_player = players[0]

	running_player.node = $Player
	trapping_player.node = null
	
	should_count_down_timer = true

	SignalBus.goal_reached.connect(_on_goal_reached)
	
	_choose_scenes()

func _process(delta: float) -> void:
	if should_count_down_timer:
		running_player.time_left -= delta
	
	print_debug("p1 at %0.2f, p2 at %0.2f" % [players[0].time_left, players[1].time_left])


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

func _on_goal_reached():
	should_count_down_timer = false
	Globals.round_number += 1
	# some round end effects and animation can happen here if wanted?

	SignalBus.ready_to_end_round.emit()
