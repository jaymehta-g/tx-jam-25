extends CanvasLayer

signal start
@onready var start_btn := %"Start Button" as TextureButton
@export var ui_sound: AudioStreamPlayer
@export var fadeout: AnimationPlayer

func _ready() -> void:
	start_btn.pressed.connect(_on_start_button)

func _on_start_button():
	start_btn.pressed.disconnect(_on_start_button)
	ui_sound.play(0.07)
	fadeout.play(&"fadeout")
	fadeout.animation_finished.connect(func(_a):
		start.emit()
	)
