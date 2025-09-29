class_name Player
extends CharacterBody2D

@export var walk_speed := 250.0
@export var run_speed := 400.0

var jump_vel := -1500.0
var just_nailbounced := false

var sprinting := false
var attack_input := false
var last_direction_right := true
var was_on_floor := true
var just_landed := false

var checkpoint_position: Vector2

var invulnerable := false
@onready var invuln_timer := $"Invulnerable Timer" as Timer

const ATTACK = preload("uid://fmrjol5xhkii")

@onready var attack_cooldown: Timer = $"Attack Cooldown"
@onready var anim_player: AnimationPlayer = $"AnimationPlayer"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_sfx := $"Hurt Sound" as AudioStreamPlayer
@onready var run_sfx: AudioStreamPlayer2D = $RunAudio
@onready var walk_sfx: AudioStreamPlayer2D = $WalkAudio
@onready var jump_sfx: AudioStreamPlayer2D = $JumpAudio
@onready var jump2_sfx: AudioStreamPlayer2D = $Jump2Audio
@onready var hit_sfx: AudioStreamPlayer2D = $HitAudio
@onready var hit2_sfx: AudioStreamPlayer2D = $HitAudio2
@onready var hit3_sfx: AudioStreamPlayer2D = $HitAudio3

@onready var blink_anim := $Blink as AnimationPlayer

@export var animation_debug := false
var in_landing_animation := false
var in_attack_animation := false

func _ready() -> void:
	SignalBus.player_hurt.connect(_on_hurt)
	SignalBus.checkpoint_hit.connect(_on_checkpoint)
	checkpoint_position = Vector2(1045, 989)
	invuln_timer.timeout.connect(_on_invuln_timer_timeout)

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
	
	if Input.is_action_just_pressed("attack"):
		attack_input = true
		in_attack_animation = true
		anim_player.play("attack")
		[hit_sfx, hit2_sfx, hit3_sfx].pick_random().play()
		
	if attack_input and attack_cooldown.is_stopped():
		attack_cooldown.start()
		attack_input = false
		
		var n := ATTACK.instantiate() as Node2D
		
		if Input.is_action_pressed("ui_down") and not is_on_floor():
			n.rotation_degrees = 90
			n.position += Vector2(15, 50)
			n.attack_hit.connect(_on_nailbounce) # only on down attack
		elif Input.is_action_pressed("ui_up"):
			n.rotation_degrees = -90
			if not last_direction_right:
				n.scale.y = -1
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
				
		velocity.y = 0

		if Input.is_action_just_pressed("jump"): velocity.y += jump_vel
	else:
		velocity.y += 3000 * delta # gravity?
		
	if velocity.y > 0:
		just_nailbounced = false # clear this state when you start falling
	if (not Input.is_action_pressed("jump")) and velocity.y < 0 and not just_nailbounced: # hollowknight like immediate fall when you let go of jump
		velocity.y = 0
		
	was_on_floor = is_on_floor() # update current frame to if we are on the floor rn

	move_and_slide()
	
	do_animations() 

func _on_nailbounce():
	velocity.y = jump_vel * 0.8
	just_nailbounced = true

func _on_hurt(): # This called from hazard and SignalBus
	if invulnerable: return
	invulnerable = true
	hurt_sfx.play(0.03)
	position = checkpoint_position
	blink_anim.play("blink")
	invuln_timer.start()

func _on_invuln_timer_timeout():
	invulnerable = false

func _on_checkpoint(p :Vector2):
	checkpoint_position = p
	
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
				run_sfx.play()
			elif not sprinting:
				anim_player.play("walk")
				if animation_debug: print("walking")
				walk_sfx.play()
		else:
			if velocity.y < 0:
				anim_player.play("jump")
				if animation_debug: print("jumping")
				[jump_sfx, jump2_sfx].pick_random().play()
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
