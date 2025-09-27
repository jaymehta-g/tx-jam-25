extends Node2D

const HAZARD = preload("uid://d1mn45ydc6cma")
const max_rooms = 3
# width of shop is 300 pixels
const stage_y_size = 1080

@onready var stage0:PackedScene = preload("res://main/stages/stage0.tscn")
@onready var stage1:PackedScene = preload("res://main/stages/stage0.tscn")
@onready var stage2:PackedScene = preload("res://main/stages/stage0.tscn")
@onready var total_stages:Array = [stage0, stage1, stage2]


# prolly don't need 
@onready var current_rooms: Array:
	get:
		return get_tree().get_nodes_in_group("Rooms")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#autoload scenes
	_choose_scenes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Camera.position.y = min($Player.position.y-500, 0)

func _choose_scenes() -> void:
	# choose 3 rooms at a random order and sequence
	var stages = total_stages.duplicate()
	stages.shuffle()
	stages = stages.slice(0, 3, 1, true)
	# need to add floor to 1st stage always - better way to do this ? 
	var first_scene = stages.pop_at(0)
	var first_room = first_scene.instantiate()
	var pos = first_room.global_position.y
	first_room.add_to_group("Rooms")
	add_child(first_room)
	
	# add the remaining 
	for stage in stages:
		var room = stage.instantiate()
		pos -= stage_y_size
		room.global_position.y = pos
		room.add_to_group("Rooms")
		add_child(room)