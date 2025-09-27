extends Node2D

const HAZARD = preload("uid://d1mn45ydc6cma")
const max_rooms = 3
# width of shop is 300 pixels
const stage_size = Vector2(1620, 1080)

@onready var stage0:PackedScene = preload("res://main/stages/stage0.tscn")
@onready var stage1:PackedScene = preload("res://main/stages/stage0.tscn")
@onready var stage2:PackedScene = preload("res://main/stages/stage0.tscn")

@onready var total_stages:Array = [stage0, stage1, stage2]


# prolly don't need 
@onready var current_rooms: Array:
	get:
		return get_tree().get_nodes_in_group("Rooms")

#var traps_left := 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#autoload scenes
	_choose_scenes()
	
	#$Player.global_position = 

	# timer.timeout.connect(func():
	# 	traps_left += 1
	# 	traps_left = min(traps_left, 5)
	# )

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta: float) -> void:
	$Camera.position.y = $Player.position.y
	
	$Camera.position.y = min($Player.position.y-500, 0)

	#label.text = "Traps Left: %s" % traps_left
	#if Input.is_action_just_pressed("click") and traps_left > 0:
	#	traps_left -= 1
	#	var pos := get_viewport().get_mouse_position()
	#	var n := HAZARD.instantiate()
	#	n.position = pos
	#	add_child(n)

func _choose_scenes() -> void:
	# choose 3 rooms at a random order and sequence
	# var stages = total_stages.duplicate().shuffle().slice(0, 2)
	var stages = total_stages.duplicate()
	stages.shuffle()
	stages = stages.slice(0, 2)
	
	# need to add floor to 1st stage always - better way to do this ? 
	var first_scene = stages.pop_at(0)
	var first_room = first_scene.instantiate()
	var pos = first_room.global_position
	first_room.add_to_group("Rooms")
	add_child(first_room)
	#var coll = get_node("Areas/Boundaries/Bottom")
	#var shape = RectangleShape2D.new()
	#shape.size = Vector2(1620, 50)
	#coll.shape = shape
	
	# add the remaining 
	for stage in stages:
		var room = stage.instantiate()
		pos += stage_size
		room.global_position = pos
		room.add_to_group("Rooms")
		add_child(room)

#func _on_stage_zone_body_entered(body: Node2D) -> void:
#	if body.is_in_group("player"):
#		print('next stage up')

#func _on_trap_timer_timeout():
#	if traps_left < 5:
#		traps_left += 1
	
	
