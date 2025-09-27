class_name Player
extends CharacterBody2D

@export var speed := 300.0
var jump_vel := -1000.0

var jump_in: bool = false
var last_direction_right := true

const ATTACK = preload("uid://fmrjol5xhkii")

func _process(delta: float) -> void:
	var inp = Input.get_axis("ui_left", "ui_right")
	if inp > 0: last_direction_right = true
	if inp < 0: last_direction_right = false
	velocity.x = inp * speed
	jump_in = Input.is_action_just_pressed("jump")
	if Input.is_action_just_pressed("attack"):
		var n := ATTACK.instantiate() as Node2D
		if Input.is_action_pressed("ui_down") and not is_on_floor():
			n.rotation_degrees = 90
		elif Input.is_action_pressed("ui_up"):
			n.rotation_degrees = -90
		elif not last_direction_right:
			n.rotation_degrees  = -180
		n.attack_hit.connect(func(): velocity.y = jump_vel * 0.8)
		add_child(n)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		velocity.y == 0
	else:
		velocity.y += 3000 * delta
	if jump_in and is_on_floor():
		jump_in = not jump_in
		velocity.y += jump_vel
	move_and_slide()
