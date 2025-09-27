class_name Player
extends CharacterBody2D

@export var speed := 400.0
var jump_vel := -1500.0
var just_nailbounced := false

var jump_input_hold: bool = false
var jump_input_just_pressed: bool = false
var attack_input := false
var last_direction_right := true

const ATTACK = preload("uid://fmrjol5xhkii")

@onready var jump_cooldown: Timer = $"Jump Cooldown"
@onready var attack_cooldown: Timer = $"Attack Cooldown"

func _ready() -> void:
	SignalBus.player_hurt.connect(_on_hurt)

func _process(delta: float) -> void:
	var inp = Input.get_axis("ui_left", "ui_right")
	if inp > 0: last_direction_right = true
	if inp < 0: last_direction_right = false
	velocity.x = inp * speed
	jump_input_hold = Input.is_action_pressed("jump")
	jump_input_just_pressed = Input.is_action_just_pressed("jump")
	if Input.is_action_just_pressed("attack"):
		attack_input = true
	if attack_input and attack_cooldown.is_stopped():
		attack_cooldown.start()
		attack_input = false
		var n := ATTACK.instantiate() as Node2D
		if Input.is_action_pressed("ui_down") and not is_on_floor():
			n.rotation_degrees = 90
			n.attack_hit.connect(_on_nailbounce) # only on down attack
		elif Input.is_action_pressed("ui_up"):
			n.rotation_degrees = -90
			n.attack_hit.connect(func(): velocity.y = max(velocity.y, 0)) # push down on up attack
		elif not last_direction_right:
			n.rotation_degrees  = -180
		
		add_child(n)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		velocity.y == 0
	else:
		velocity.y += 3000 * delta
	if jump_input_just_pressed and jump_cooldown.is_stopped() and is_on_floor():
		jump_input_just_pressed = false
		jump_cooldown.start()
		velocity.y += jump_vel
	if velocity.y > 0:
		just_nailbounced = false # clear this state when you start falling
	if (not jump_input_hold) and velocity.y < 0 and not just_nailbounced: # hollowknight like immediate fall when you let go of jump
		velocity.y = 0
	move_and_slide()

func _on_nailbounce():
	velocity.y = jump_vel * 0.8
	just_nailbounced = true

func _on_hurt(): # This called from hazard and SignalBus
	position = Vector2(900, 300) # TODO
