extends CanvasLayer

signal start
@onready var start_btn := %"Start Button" as Button

func _ready() -> void:
    start_btn.pressed.connect(func(): 
        start.emit()
    )
