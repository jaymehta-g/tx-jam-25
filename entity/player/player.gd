class_name Player
extends CharacterBody2D

@export var walk_speed := 250.0
@export var run_speed := 400.0

var jump_vel := -1500.0
var just_nailbounced := false

var sprinting := false
var jump_input_hold: bool = false
var jump_input_just_pressed: bool = false
var attack_input := false
var last_direction_right := true
var was_on_floor := true
var just_landed := false

const ATTACK = preload("uid://fmrjol5xhkii")

@onready var jump_cooldown: Timer = $"Jump Cooldown"
@onready var attack_cooldown: Timer = $"Attack Cooldown"
@onready var anim_player: AnimationPlayer = $"AnimationPlayer"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_sfx := $"Hurt Sound" as AudioStreamPlayer

@export var animation_debug := false
var in_landing_animation := false
var in_attack_animation := false

func _ready() -> void:
	SignalBus.player_hurt.connect(_on_hurt)

func _process(delta: float) -> void:
	
	var inp = Input.get_axis("ui_left", "ui_right")
	if inp > 0: last_direction_right = true
	if inp < 0: last_direction_right = false
	
	sprinting = Input.is_action_pressed("sprint")

	# walk/run speed
	if sprinting:
		velocity.x = inp * run_speed
	else:
		velocity.x = inp * walk_speed
	
	
	jump_input_hold = Input.is_action_pressed("jump")
	jump_input_just_pressed = Input.is_action_just_pressed("jump")
	
	if Input.is_action_just_pressed("attack"):
		attack_input = true
		in_attack_animation = true
		anim_player.play("attack")
		
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
			n.scale.x  = -1
		
		add_child(n)

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		if not was_on_floor: # check last frame if we are on the floor
			just_landed = true # if not on floor we are just landing
		else:
			just_landed = false # still on the floor
			
		velocity.y == 0
	else:
		velocity.y += 3000 * delta # gravity?
		
		# pressed jump key
	if jump_input_just_pressed and is_on_floor(): # and jump_cooldown.is_stopped():
		jump_input_just_pressed = false
		jump_cooldown.start()
		velocity.y += jump_vel # jump

	if velocity.y > 0:
		just_nailbounced = false # clear this state when you start falling
	if (not jump_input_hold) and velocity.y < 0 and not just_nailbounced: # hollowknight like immediate fall when you let go of jump
		velocity.y = 0
		
	was_on_floor = is_on_floor() # update current frame to if we are on the floor rn

	move_and_slide()
	
	do_animations() 

func _on_nailbounce():
	velocity.y = jump_vel * 0.8
	just_nailbounced = true

func _on_hurt(): # This called from hazard and SignalBus
	hurt_sfx.play(0.03)
	position = Vector2(900, 300) # TODO
	
func do_animations():
	
	# just landing on the floor, play the landing animation
	if just_landed and is_on_floor():
		anim_player.play("land")
		if animation_debug: print("land")
		in_landing_animation = true # set flag so that we dont start other animations till we done landing

	elif not in_landing_animation and not in_attack_animation:
		# if we are not playing the landing animation
		if is_on_floor():
			if abs(velocity.x) < 1:
				anim_player.play("idle")
				if animation_debug: print("idle")
			elif sprinting:
				anim_player.play("run")
				if animation_debug: print("run")
			elif not sprinting:
				anim_player.play("walk")
				if animation_debug: print("walking")
		else:
			if velocity.y < 0:
				anim_player.play("jump")
				if animation_debug: print("jumping")
			else: 
				anim_player.play("fall")
				if animation_debug: print("falling")
		sprite_2d.flip_h = not last_direction_right


# set flag for if we are finished with the  animation
func _on_animation_finished(anim_name: StringName) -> void:
	if in_landing_animation:
		in_landing_animation = false
	if in_attack_animation:
		in_attack_animation = false
